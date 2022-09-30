data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_secretsmanager_secret_version" "creds" {
  # Here goes the name you gave to your secret
  secret_id = "envdot"
}

# Decode from json
locals {
  env_dot = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

data "template_file" "init" {
  template = "${file(var.user_data)}"

  vars = {
    api_key = "${locals.env_dot.api_key}"
	api_secret = "${locals.env_dot.api_secret}"
  }
}