#----------Bucket output----------#
output "Bucket_name" {
  value       = module.aws-s3.bucket_name
  description = "Show created bucket name for this module"
}

#----------Server output----------#
output "Server_info" {
  value       = module.aws-instance.server_info
  description = "Show server info: ID, Instance type, AMI, SSH key name, External IP ore DNS, Internal IP Project, Owner, Project, Env"
}

#----------VPC output----------#
output "VPC_id" {
  value       = module.aws-vpc.vpc_id
  description = "Show VPC id"
}

#----------EIP output----------#
output "Elastic_IPs" {
  value       = module.aws-eip.eip_ip
  description = "Show Elastic IP"
}

#----------Route53 output----------#
output "Route53_subdomain" {
  value       = module.aws-route53.route53_fqdn
  description = "Show FQDN"
}