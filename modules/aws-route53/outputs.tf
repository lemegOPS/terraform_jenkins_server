output "route53_fqdn" {
  value = aws_route53_record.subdomain_jenkins_server.name
}