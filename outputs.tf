output "n8n_public_ip" {
  description = "Public IP of the n8n EC2 instance"
  value       = aws_instance.n8n.public_ip
}

output "n8n_url" {
  description = "URL to access n8n"
  value       = "http://${aws_eip.n8n_eip.public_ip}:5678"
}
