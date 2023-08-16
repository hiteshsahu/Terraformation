# Local Variables : Local values are like a function's temporary local variables.
#  https://developer.hashicorp.com/terraform/language/values/locals
locals {
  project_name   = "Terraforming"
  default_region = "us-east-1a"
  ami            = "ami-08a52ddb321b32a8c"
  type           = "t2.micro"
  tags = {
    Name = "Amazon Ubuntu"
    Env  = "Dev"
    Name = "web - ${terraform.workspace}" # Save Workspace
  }
  # subnet = "subnet-76a8163a"
  # nic    = aws_network_interface.my_nic.id
}

# Input Variables:  like function arguments.
# https://developer.hashicorp.com/terraform/language/values/variables
# Subnet within VPC
variable "subnet_blocks" {
  type = map(object({
    name       = string,
    cidr_block = string
  }))
  default = {
    "prod" = {
      name       = "prod_subnet",
      cidr_block = "10.0.1.0/24"
    },
    "dev" = {
      name       = "dev_subnet",
      cidr_block = "10.0.2.0/24"
    },
    "qa" = {
      name       = "qa_subnet",
      cidr_block = "10.0.3.0/24"
  } }
}
