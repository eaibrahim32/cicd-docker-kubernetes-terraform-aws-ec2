provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "app_sg" {
  name        = "devops-${var.environment}-sg"
  description = "Allow SSH and app traffic for ${var.environment}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "devops-${var.environment}-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0df749f12c31d3cd6"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-USERDATA
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              USERDATA

  tags = {
    Name        = "devops-${var.environment}-server"
    Environment = var.environment
  }
}
