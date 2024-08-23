#----------- Elastic IP create block ----------#

resource "aws_eip" "jenkins_eip" {
  domain   = "vpc"
  instance = var.instance_id
  tags     = merge(var.tags, { Name = "${var.global_name}_eip" })
}
