variable "custom_port" {
  type    = string
  default = 8080
}

output "instance_ip_addr" {
  value = aws_instance.server.private_ip
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}