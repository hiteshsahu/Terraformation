
# OutPut Variables: function return values.
# https://developer.hashicorp.com/terraform/language/values/outputs
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