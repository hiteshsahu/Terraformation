# -----------Resources----------
/**
resource "<provider>_<resource_type>" "name" { config options.....
key = "value"
key2 = "another value" 
}
**/


# Local Variables : 
locals {
  project_name   = "Terraforming"
  default_region = "us-east-1a"
  ami            = "ami-08a52ddb321b32a8c"
  type           = "t2.micro"
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
    Name = "prod vpc ${local.project_name}"
  }
}

# Create Internet gateway for VPC
resource "aws_internet_gateway" "prod-gw" {
  vpc_id = aws_vpc.prod-vpc.id
  tags = {
    Name = "prod gw ${local.project_name}"
  }
}


# Create Custom Route Table for Internet Gateway of VPC
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.prod-gw.id
  }

  tags = {
    Name = "prod route table ${local.project_name}"
  }
}

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

# Create Subnet within VPC using for_each on Map
resource "aws_subnet" "prod_subnet" {
  for_each          = var.subnet_blocks
  vpc_id            = aws_vpc.prod-vpc.id # reference prod-vpc.id to create subnet
  cidr_block        = each.value.cidr_block
  availability_zone = local.default_region

  tags = {
    Name = "Subnet ${each.value.name}"
  }
}

# Associate subnets with Route Table
resource "aws_route_table_association" "a" {
  for_each       = aws_subnet.prod_subnet
  subnet_id      = each.value.id #aws_subnet.prod_subnet.id
  route_table_id = aws_route_table.prod-route-table.id
}

#  Create Security Group to allow port 22,80,443
resource "aws_security_group" "sg_allow_web" {
  name        = "allow_web_traffic_security_group"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Group to allow port 22,80,443"
  }
}

# Create NIC (network interface) with an ip in each subnet
resource "aws_network_interface" "web-server-nic" {
  description = "Prod NIC for subnet"

  for_each        = aws_subnet.prod_subnet
  subnet_id       = each.value.id #aws_subnet.prod_subnet.id
  security_groups = [aws_security_group.sg_allow_web.id]
  # private_ips     = ["10.0.1.50"] 

  tags = {
    Name = "Prod NIC ${local.project_name}"
  }
}

resource "aws_eip" "one" {

  for_each = aws_network_interface.web-server-nic
  # vpc               = true
  network_interface = each.value.id
  # associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.prod-gw]
}


# Start EC2 Instances
resource "aws_instance" "web" {

  //count = 1     # Meta Argument COUNT: create similar EC2 instances

  for_each      = aws_network_interface.web-server-nic
  ami           = local.ami
  instance_type = local.type
  tags          = local.tags

  network_interface {
    network_interface_id = each.value.id
    device_index         = 0
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF

}


# OutPut: https://developer.hashicorp.com/terraform/language/values/outputs
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = [for instance in aws_instance.web : instance.public_ip]
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value = {
    for key, instance in aws_instance.web : key => instance.private_ip
  }
}

output "instance_id" {
  description = "instance ID of the EC2 instance"
  value = {
    for key, instance in aws_instance.web : key => instance.id
  }
}

# # Create users using for_each on set
# resource "aws_iam_user" "the-accounts" {
#   for_each = toset(["Todd", "James", "Alice", "Dottie"])
#   name     = each.key
# }


