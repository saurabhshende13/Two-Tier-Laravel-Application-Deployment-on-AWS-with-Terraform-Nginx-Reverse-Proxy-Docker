variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet" {
  description = "Public subnet CIDR"
  type = list(string)
}

variable "private_subnet" {
  description = "Private subnet CIDR"
  type = list(string)
}

variable "az" {
  description = "Availability Zone"
  type = list(string)
}

variable "nginx_ami" {
  description = "AMI ID for Nginx server"
  type        = string

}

variable "nginx_instance_type" {
  type = string
}

variable "app_ami" {
  description = "AMI ID with Docker + App baked"
  type        = string
}

variable "app_instance_type" {
  type = string
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "region" {
  description = "AWS Region"
}

variable "certificate_arn " {
  description = "ACM Certificate ARN for HTTPS"
}