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
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
}

variable "vpc_enable_vpn_gateway" {
  description = "Enable VPN gateway for VPC"
  type        = bool
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default     = local.common_tags
}

variable "s3_bucket_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "SimpleBucket"
}
