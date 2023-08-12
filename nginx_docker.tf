/*
* Example of using Docker to run NGINX server 
*/


# -----------Required Provider ----------

terraform {

  # Terraform relies on plugins called "providers" to interact with remote systems
  required_providers {
    docker = {                       # Source Local Name 
      source  = "kreuzwerker/docker" # Source Address to Terraform Registry [<HOSTNAME>/]<NAMESPACE>/<TYPE>
      version = "~> 3.0.1"           # Compatible Version on https://registry.terraform.io/browse/providers?product_intent=terraform
    }

    aws = {
      source  = "hashicorp/aws"
      version = "5.12.0"
    }
  }
}

# -----------Provider Configuration----------

# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  region = "us-east-1"
}

# Additional provider configuration for west coast region; resources can
# reference this as `aws.west`.
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

provider "docker" {
  # Configuration options
  host = "npipe:////.//pipe//docker_engine"
}

# -----------Resources----------
/**
Each resource block describes one or more infrastructure objects,
 such as virtual networks, compute instances, or higher-level components such as DNS records.
**/


resource "azurerm_resource_group" "rg" {

  # Create resource group using for_each on array
  for_each = {
    a_group       = "eastus"
    another_group = "westus2"
  }
  name     = each.key
  location = each.value
}

# Create users using for_each on set
resource "aws_iam_user" "the-accounts" {
  for_each = toset(["Todd", "James", "Alice", "Dottie"])
  name     = each.key
}

module "bucket" {
  for_each = toset(["assets", "media"])
  source   = "./publish_bucket"
  name     = "${each.key}_bucket"
}

resource "aws_instance" "web" { #  resource type: determines the kind of infrastructure object it manages 
  count = 4                     # Meta Argument COUNT: create four similar EC2 instances

  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"

  tags = {
    Name = "Server ${count.index}"
  }
}



resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  ports {
    internal = 80
    external = 8000
  }
}
