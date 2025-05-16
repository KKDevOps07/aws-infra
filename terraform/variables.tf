variable "aws_region" {
  type = string
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
  default     = "kk1.pem"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vpc_name" {
  default = "main-vpc"
}

variable "availability_zone" {
  description = "Primary availability zone"
  default     = "us-west-2a"
}

variable "availability_zone_az2" {
  description = "Secondary availability zone"
  default     = "us-west-2b"
}

variable "public_subnet_name" {
  default = "public-subnet"
}

variable "private_subnet_name" {
  default = "private-subnet"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "192.168.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "192.168.2.0/24"
}

variable "public_subnet_cidr_az2" {
  description = "CIDR block for the public subnet in the second availability zone"
  type        = string
  default     = "192.168.3.0/24"
}

variable "private_subnet_cidr_az2" {
  description = "CIDR block for the private subnet in the second availability zone"
  type        = string
  default     = "192.168.4.0/24"
}

variable "public_subnet_name_az2" {
  default = "public-subnet-az2"
}

variable "private_subnet_name_az2" {
  default = "private-subnet-az2"
}

variable "igw_name" {
  default = "main-igw"
}

variable "public_route_table_name" {
  default = "public-route-table"
}

variable "private_route_table_name" {
  default = "private-route-table"
}

variable "nat_gateway_name" {
  default = "nat-gateway"
}

variable "trusted_ip_range" {
  default = "0.0.0.0/0" # Replace with your trusted IP range
}

variable "kubernetes_sg_name" {
  default = "kubernetes-sg"
}

# variable "rds_allocated_storage" {
#   default = 20
# }

# variable "rds_engine_version" {
#   default = "8.0"
# }

# variable "rds_instance_class" {
#   default = "db.t2.medium"
# }

# variable "rds_db_name" {
#   default = "mydb"
# }

# variable "rds_username" {
#   default = "admin"
# }

# variable "rds_password" {
#   default = "password123"
# }

# variable "rds_name" {
#   default = "mysql-db"
# }

variable "db_subnet_group_name" {
  default = "main-db-subnet-group"
}

variable "ami_id" {
  default = "ami-075686beab831bb7f" # Replace with the correct Ubuntu AMI for your region
}

variable "instance_type" {
  default = "t2.medium"                         
}

variable "nlb_name" {
  default = "network-load-balancer"
}

variable "alb_name" {
  default = "application-load-balancer"
}
