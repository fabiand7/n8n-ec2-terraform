output "n8n_public_ip" {
  description = "Public IP of the n8n EC2 instance"
  value       = aws_instance.n8n.public_ip
}

output "n8n_url" {
  description = "URL to access n8n"
  value       = "http://${aws_eip.n8n_eip.public_ip}:5678"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i n8n-key.pem ubuntu@${aws_eip.n8n_eip.public_ip}"
}

output "key_pair_name" {
  description = "Name of the generated key pair"
  value       = aws_key_pair.n8n_key_pair.key_name
}

output "ebs_volume_id" {
  description = "ID of the EBS volume"
  value       = aws_ebs_volume.n8n_volume.id
}