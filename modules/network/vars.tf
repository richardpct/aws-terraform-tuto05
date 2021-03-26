locals {
  ssh_port       = 22
  http_port      = 80
  https_port     = 443
  redis_port     = 6379
  webserver_port = 8000
  anywhere       = ["0.0.0.0/0"]
}

variable "region" {
  description = "region"
}

variable "env" {
  description = "environment"
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
}

variable "subnet_public_nat" {
  description = "public subnet nat"
}

variable "subnet_public_bastion" {
  description = "public subnet bastion"
}

variable "subnet_public_web" {
  description = "public subnet web"
}

variable "subnet_private" {
  description = "private subnet"
}

variable "cidr_allowed_ssh" {
  description = "cidr block allowed to connect via SSH"
}
