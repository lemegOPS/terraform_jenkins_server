output "server_info" {
  value = {
    server_name          = aws_instance.server.tags["Name"]
    server_id            = aws_instance.server.id
    server_ami           = aws_instance.server.ami
    server_key_name      = aws_instance.server.key_name
    server_instance_type = aws_instance.server.instance_type
  }
}

output "servers" {
  value = aws_instance.server.id
}
