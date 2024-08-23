#----------- Global variables -----------#

variable "profile" {
  default     = "aws_own"
  description = "Use if you have a profile. More security decision. Use this map to separate env. in accounts"
}

variable "region" {
  default     = "ca-central-1"
  description = "Use this map to separate env. in more cheaper ore close to your clients countries"
}

variable "tags" {
  type = map(any)
  default = {
    Owner   = "Alex"
    Project = "Prod"
    Name    = "Jenkins"
  }
  description = "Use this map of tags. Use to generate bucket name, names or resources, tags. See global_name in module"
}


#----------- Instance variables -----------#

variable "instance_type" {
  default     = "t2.small"
  description = "Use this map of the instance type. Use to make our env more flexible"
}

variable "ami_image" {
  type = object({
    ami_owners       = list(string)
    ami_filter_value = list(string)
    ami_filter_name  = string
  })
  default = {
    ami_owners       = ["amazon"]
    ami_filter_value = ["amzn2-ami-hvm-*-x86_64-gp2"]
    ami_filter_name  = "name"
  }
  description = "Add owner and ami_name to search and choose most recent ami"
}


#----------- VPC variables -----------#

variable "cidr_block" {
  type = map(any)
  default = {
    external = "0.0.0.0/0"
    internal = "10.0.0.0/16"
  }
  description = "Cidr Block map. Use for network"
}

variable "sg_port" {
  default     = ["22", "80", "8080", "443"]
  description = "Ports for Security group. Also map for diferent env."
}


#----------- Route53 variables -----------#

variable "route53_zone" {
  default     = "lemegops.com"
  description = "Add you domain in AWS"
}

variable "subdomain" {
  default     = "jen"
  description = "Add sundomain to create in AWS"
}