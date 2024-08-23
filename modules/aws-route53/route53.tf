#----------- Route53 subdomain create block ----------#

data "aws_route53_zone" "jenkins_server" {
  name = var.route53_zone
}

resource "aws_route53_record" "subdomain_jenkins_server" {
  zone_id = data.aws_route53_zone.jenkins_server.zone_id
  name    = "${var.subdomain}.${data.aws_route53_zone.jenkins_server.name}"
  type    = "A"
  ttl     = "300"
  records = [var.eip_ip]
}