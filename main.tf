terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "n8n_sg" {
  name        = "n8n-sg"
  description = "Allow HTTP, HTTPS, and n8n ports"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5678
    to_port     = 5678
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "n8n" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.n8n_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io docker-compose
    systemctl start docker
    systemctl enable docker
    mkdir -p /data/n8n
    docker run -d --name n8n --restart=always -p 5678:5678  -e N8N_BASIC_AUTH_ACTIVE=true -e N8N_SECURE_COOKIE=false -e N8N_BASIC_AUTH_USER=${var.n8n_user}  -e N8N_BASIC_AUTH_PASSWORD=${var.n8n_password} n8nio/n8n
  EOF

  tags = {
    Name = "n8n-server"
  }
}

resource "aws_eip" "n8n_eip" {
  instance = aws_instance.n8n.id
}
