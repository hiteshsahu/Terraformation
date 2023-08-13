# -----------Provider ----------
# Configure the AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

# -----------Provider Configuration----------

# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "%USERPROFILE%/.aws/credentials"
  profile                 = "default"
}

# Additional provider configuration for west coast region; resources can
# reference this as `aws.west`.
provider "aws" {
  alias                   = "west"
  region                  = "us-west-2"
  shared_credentials_file = "%USERPROFILE%/.aws/credentials"
  profile                 = "default"
}

