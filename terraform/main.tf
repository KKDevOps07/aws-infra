# ==========================
# VPC Configuration
# ==========================
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# ==========================
# Subnet Configuration
# ==========================
# Public Subnet (AZ1)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
  tags = {
    Name = var.public_subnet_name
  }
}

# Private Subnet (AZ1)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_az2
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_az2
  tags = {
    Name = var.public_subnet_name_az2
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_az2
  availability_zone = var.availability_zone_az2
  tags = {
    Name = var.private_subnet_name_az2
  }
}

# ==========================
# Internet Gateway and NAT
# ==========================
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = var.nat_gateway_name
  }
}

# ==========================
# Route Tables
# ==========================
# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Route Table for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# ==========================
# Security Groups
# ==========================
# Security Group for Kubernetes (Master and Slave Nodes)
resource "aws_security_group" "kubernetes" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.bastion.private_ip}/32"] # Allow SSH only from Bastion Host
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.trusted_ip_range]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.kubernetes_sg_name
  }
}

# Security Group for Bastion Host
resource "aws_security_group" "bastion" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with a specific IP range for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# ==========================
# RDS MySQL Database
# ==========================
# resource "aws_db_instance" "mysql" {
#   allocated_storage      = var.rds_allocated_storage
#   engine                 = "mysql"
#   engine_version         = "8.0.34"
#   instance_class         = "db.t3.medium"
#   db_name                = var.rds_db_name
#   username               = var.rds_username
#   password               = var.rds_password
#   parameter_group_name   = "default.mysql8.0"
#   publicly_accessible    = false
#   vpc_security_group_ids = [aws_security_group.kubernetes.id]
#   db_subnet_group_name   = aws_db_subnet_group.main.name
#   tags = {
#     Name = var.rds_name
#   }

#   skip_final_snapshot       = false
#   final_snapshot_identifier = "final-snapshot-example-${terraform.workspace}"
# }

# resource "aws_db_subnet_group" "main" {
#   name       = var.db_subnet_group_name
#   subnet_ids = [aws_subnet.private.id, aws_subnet.public_az2.id]
#   tags = {
#     Name = var.db_subnet_group_name
#   }
# }

# ==========================
# EC2 Instances
# ==========================
# Bastion Host (Access Point for Developers/DevOps)
resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = "kk1"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  instance_market_options {
    market_type = "spot"
  }
  tags = {
    Name = "bastion-host"
  }
}

# Master Node (Accessed via Bastion Host by Developers/DevOps)
resource "aws_instance" "master" {
  ami                    = var.ami_id
  instance_type          = "t2.medium"
  key_name               = "kk1"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.kubernetes.id]
  tags = {
    Name = "master-node"
  }

}

# Slave Nodes (Accessed by Users via Kubernetes API)
resource "aws_instance" "slave" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = "kk1"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.kubernetes.id]
  tags = {
    Name = "slave-node-${count.index + 1}"
  }
}

