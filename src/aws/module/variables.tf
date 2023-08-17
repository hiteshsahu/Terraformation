# Local Variables : 
locals {
  project_name       = "Terraforming"
  default_region     = "us-east-1a"
  ami                = "ami-08a52ddb321b32a8c"
  type               = "t2.micro"
  vpc_module_version = "5.1.1"
  ec2_module_version = "5.2.1"

  tags = {
    Name = "Amazon Ubuntu"
    Env  = "Dev"
  }

  common_tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Input Variables
variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "module-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = true
}

variable "vpc_enable_vpn_gateway" {
  description = "Enable VPN gateway for VPC"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default     = local.common_tags
}
