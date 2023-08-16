
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.12.0"
    }
  }
}

# Run "terraform configure" to generate files
locals {
  credentials_file_location = "C:/Users/hites/.aws/credentials"
  config_file_location      = "C:/Users/hites/.aws/config"
}

# -----------Provider Configuration----------

# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  shared_credentials_files = [local.credentials_file_location]
  shared_config_files      = [local.config_file_location]
  region           = "us-east-1"
}
