# Provision AWS VPC, EC2 & S3 using Modules

Provisions EC2 Instances & VPC using AWS Terraform registry modules & S3 Bucket using a Local module

Get all local modules by running Terraform get.
> terraform get

Initialize Provider & Modules
> terraform init

Provision the infrastructure
> terraform apply -auto-apply