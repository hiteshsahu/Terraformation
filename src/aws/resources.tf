# -----------Resources----------
/**
resource "<provider>_<resource_type>" "name" { config options.....
key = "value"
key2 = "another value" 
}
**/


# Local Variables : 
locals {
  region = "us-east-1a"
  ami    = "ami-08a52ddb321b32a8c"
  type   = "t2.micro"
  tags = {
    Name = "Amazon Ubuntu"
    Env  = "Dev"
  }
  # subnet = "subnet-76a8163a"
  # nic    = aws_network_interface.my_nic.id
}

# Create a VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

variable "subnet_blocks" {
  type = map(object({
    name       = string,
    cidr_block = string
  }))
 default= {
    "prod" = {
      name       = "prod_subnet",
      cidr_block = "10.0.1.0/24"
    },
   "dev" =  {
      name       = "dev_subnet",
      cidr_block = "10.0.2.0/24"
    },
    "qa" = {
      name       = "qa_subnet",
      cidr_block = "10.0.3.0/24"
    }}
}

# Create Subnet within VPC using for_each on Map
resource "aws_subnet" "subnet" {

  for_each = var.subnet_blocks
  vpc_id            = aws_vpc.prod-vpc.id # reference prod-vpc.id to create subnet
  cidr_block        = each.value.cidr_block
  availability_zone = local.region

  tags = {
    Name = each.value.name
  }
}

# Start EC2 Instances
resource "aws_instance" "web" { #  resource type: determines the kind of infrastructure object it manages 
  count = 1                     # Meta Argument COUNT: create four similar EC2 instances

  ami           = local.ami
  instance_type = local.type
  tags          = local.tags
}

# # Create users using for_each on set
# resource "aws_iam_user" "the-accounts" {
#   for_each = toset(["Todd", "James", "Alice", "Dottie"])
#   name     = each.key
# }


