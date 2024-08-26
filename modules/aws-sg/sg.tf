#---------- Security Group block ----------#

data "http" "local_external_ip" {
  url = "http://ifconfig.co/ip"
}

resource "aws_security_group" "vpc_security_group" {
  name   = "${var.global_name}_SG"
  vpc_id = var.vpc_id
  tags   = var.propper_tags
}

resource "aws_security_group_rule" "full_allow_from_local_ip_to_ssh" {
  description       = "Allow all ports from your local IP (you PC IP)"
  security_group_id = aws_security_group.vpc_security_group.id
  count             = length(var.sg_port_sec)
  type              = "ingress"
  from_port         = tonumber(var.sg_port_sec[count.index])
  to_port           = tonumber(var.sg_port_sec[count.index])
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.local_external_ip.response_body)}/32"]
}

resource "aws_security_group_rule" "full_allow_from_local_ip_to_https" {
  description       = "Allow all ports from your local IP (you PC IP)"
  security_group_id = aws_security_group.vpc_security_group.id
  count             = length(var.sg_port_web)
  type              = "ingress"
  from_port         = tonumber(var.sg_port_web[count.index])
  to_port           = tonumber(var.sg_port_web[count.index])
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_block["external"]]
}

resource "aws_security_group_rule" "full_egress_rule" {
  description       = "Allow all outgoing traffic"
  security_group_id = aws_security_group.vpc_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.cidr_block["external"]]
}