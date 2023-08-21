# Provision AWS VPC, EC2 & S3 using Modules

Provisions EC2 Instances & VPC using AWS Terraform registry modules & S3 Bucket using a Local module

Get all local modules by running Terraform get.
> terraform get

Initialize Provider & Modules
> terraform init

Provision the infrastructure
> terraform apply -auto-apply

Upload Files

        aws s3 cp modules/aws-s3-static-website-bucket/www/ s3://$(terraform output -raw website_bucket_name)/ --recursive
        upload: modules/aws-s3-static-website-bucket/www/error.html to s3://robin-test-2020-01-15/error.html
        upload: modules/aws-s3-static-website-bucket/www/index.html to s3://robin-test-2020-01-15 /index.html


Delete files

        aws s3 rm s3://$(terraform output -raw website_bucket_name)/ --recursive
        delete: s3://robin-test-2020-01-15/index.html
        delete: s3://robin-test-2020-01-15/error.html

Destroy
> terraform destroy -auto-apply