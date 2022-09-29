output "docker_ip" {
  value = aws_instance.docker_node.public_ip
}