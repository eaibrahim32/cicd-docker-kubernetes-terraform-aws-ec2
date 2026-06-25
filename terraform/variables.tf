variable "aws_region" {
  default = "ap-southeast-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "devops-key"
}

variable "environment" {
  default = "prod"
}

variable "app_port" {
  default = 5000
}
