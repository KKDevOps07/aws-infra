variable "aws_region" {
  default = "eu-west-1"
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "vpc_name" {
  default = "main-vpc"
}

variable "availability_zone" {
  default = "eu-west-1a" # Replace with your desired availability zone
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
  description = "CIDR block for the public subnet"
  type        = string
  default     = "192.168.2.0/24"
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

variable "rds_allocated_storage" {
  default = 20
}

variable "rds_engine_version" {
  default = "8.0"
}

variable "rds_instance_class" {
  default = "db.t2.medium"
}

variable "rds_db_name" {
  default = "mydb"
}

variable "rds_username" {
  default = "admin"
}

variable "rds_password" {
  default = "password123"
}

variable "rds_name" {
  default = "mysql-db"
}

variable "db_subnet_group_name" {
  default = "main-db-subnet-group"
}

variable "ami_id" {
  default = "ami-0d5eff06f840b45e9" # Replace with the correct Ubuntu AMI for your region
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
  default     = "kk.pem"
}

variable "public_subnet_cidr_az2" {
  description = "CIDR block for the public subnet in the second availability zone"
  type        = string
  default     = "10.0.3.0/24" # Adjusted CIDR block
}

variable "private_subnet_cidr_az2" {
  description = "CIDR block for the private subnet in the second availability zone"
  type        = string
  default     = "10.0.4.0/24" # Adjusted CIDR block
}

# Add your variable declarations here

variable "public_subnet_name_az2" {
  description = "Name of the public subnet in availability zone 2"
  type        = string
  default     = "public-subnet-az2"
}

# Add your variable declarations here

variable "private_subnet_name_az2" {
  description = "Name of the private subnet in availability zone 2"
  type        = string
  default     = "private-subnet-az2" # Replace with your desired default value
}