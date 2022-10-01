resource "aws_vpc" "project_two_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "project_two_public_subnet" {
  vpc_id                  = aws_vpc.project_two_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "project_two_internet_gateway" {
  vpc_id = aws_vpc.project_two_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "project_two_public_rt" {
  vpc_id = aws_vpc.project_two_vpc.id
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.project_two_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.project_two_internet_gateway.id
}

resource "aws_route_table_association" "project_two_public_assoc" {
  subnet_id      = aws_subnet.project_two_public_subnet.id
  route_table_id = aws_route_table.project_two_public_rt.id
}

resource "aws_security_group" "project_two_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.project_two_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.local_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "project_two_auth" {
  key_name   = "mtc-key"
  public_key = file("~/.ssh/mtckey.pub")
}

resource "aws_instance" "docker_node" {
  ami                    = data.aws_ami.server_ami.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.project_two_auth.id
  vpc_security_group_ids = [aws_security_group.project_two_sg.id]
  subnet_id              = aws_subnet.project_two_public_subnet.id
  user_data              = data.template_file.init.rendered

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-node"
  }

  provisioner "local-exec" {
    command = templatefile("linux-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu"
      identityfile = "~/.ssh/mtckey"
    })
    interpreter = ["bash", "-c"]
  }
}