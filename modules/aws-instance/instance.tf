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
  user_data              = file("userdata.sh")
  key_name               = var.private_key_name
  vpc_security_group_ids = [var.vpc_security_group]
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags]
  }
  tags = merge(var.tags, { Name = "${var.global_name}" })
  volume_tags = merge(var.tags, { Name = "${var.global_name}_ebs" })
}


