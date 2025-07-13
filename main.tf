terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

# Generar clave privada RSA
resource "tls_private_key" "n8n_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Crear AWS Key Pair usando la clave pública generada
resource "aws_key_pair" "n8n_key_pair" {
  key_name   = "n8n-key"
  public_key = tls_private_key.n8n_key.public_key_openssh
}

# Guardar la clave privada en un archivo local
resource "local_file" "private_key" {
  content  = tls_private_key.n8n_key.private_key_pem
  filename = "n8n-key.pem"
  file_permission = "0600"
}

resource "aws_security_group" "n8n_sg" {
  name        = "n8n-sg"
  description = "Allow HTTP, HTTPS, and n8n ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
  key_name        = aws_key_pair.n8n_key_pair.key_name
  security_groups = [aws_security_group.n8n_sg.name]

  # Configurar el volumen raíz
  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    encrypted             = true
    delete_on_termination = true
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io docker-compose
    systemctl start docker
    systemctl enable docker
    sudo docker run -d --restart unless-stopped -it --name n8n -p 5678:5678 -e N8N_HOST="n8n.dominio.com" -e WEBHOOK_TUNNEL_URL=${var.n8n_domain} -e WEBHOOK_URL=${var.n8n_domain} -v ~/.n8n:/root/.n8n n8nio/n8n
  EOF

  tags = {
    Name = "n8n-server"
  }
}

resource "aws_eip" "n8n_eip" {
  instance = aws_instance.n8n.id
}
