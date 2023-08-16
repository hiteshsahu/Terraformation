# module "s3-bucket_example_complete" {
#   source  = "terraform-aws-modules/s3-bucket/aws//examples/complete"
#   version = "3.14.1"
# }


# 
# Example of creating VPC using Module

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "my-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway = true
#   enable_vpn_gateway = true

#   tags = {
#     Terraform = "true"
#     Environment = "dev"
#   }
# }
# 


# Create VPC usi9ng AWS module: 
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway
  enable_vpn_gateway = var.vpc_enable_vpn_gateway

  tags = var.vpc_tags

  #  enable_classiclink             = true
  #  enable_classiclink_dns_support = true

}

# EC2 Module
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance
module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  count = 2
  name  = "my-ec2-cluster-${count.index}"

  ami                    = local.ami
  instance_type          = local.type
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = local.tags
}
