variable "aws_region" {
  description = "AWS region to deploy to"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 in your region"
  default     = "ami-053b0d53c279acc90" # Ubuntu 22.04 LTS for us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "n8n_user" {
  description = "n8n basic auth username"
  default     = "admin"
}

variable "n8n_password" {
  description = "n8n basic auth password"
  default     = "changeme"
}
