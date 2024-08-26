#----------- AWS AMI & AMI data block ----------#

data "aws_ami" "image" {
  owners      = var.ami_image["ami_owners"]
  most_recent = true
  filter {
    name   = var.ami_image["ami_filter_name"]
    values = var.ami_image["ami_filter_value"]
  }
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.image.id
  instance_type          = var.instance_type
  key_name               = var.private_key_name
  vpc_security_group_ids = [var.vpc_security_group]

  user_data = templatefile("userdata.tpl", {
    route53_zone  = var.route53_zone
    subdomain     = var.subdomain
    certbot_email = var.certbot_email
  })
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags]
  }
  tags        = merge(var.tags, { Name = "${var.global_name}_instance" })
  volume_tags = merge(var.tags, { Name = "${var.global_name}_ebs" })
}




