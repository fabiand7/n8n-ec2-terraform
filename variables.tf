variable "aws_region" {
  description = "AWS region to deploy to"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile"
  default     = "profile"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 in your region"
  default     = "ami-053b0d53c279acc90" # Ubuntu 22.04 LTS for us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "n8n_domain" {
  description = "n8n domain"
  default     = "https://example.com/"
}

variable "volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 30
}

variable "volume_type" {
  description = "EBS volume type"
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.volume_type)
    error_message = "Volume type must be one of: gp2, gp3, io1, io2."
  }
}