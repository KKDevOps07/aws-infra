
variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-0534c98532a937968"
}

variable "public_subnet_id" {
  description = "Public subnet ID for Jenkins"
  type        = string
  default     = "subnet-0136fad760259e616"
}

variable "jenkins_ami" {
  description = "AMI ID for Jenkins EC2"
  type        = string
  default     = "ami-04999cd8f2624f834"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "kk1"
}

variable "trusted_ip_range" {
  description = "CIDR block allowed to access Jenkins and SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}	