variable "aws_profile" {
  description = "aws profile"
}

variable "region" {
  description = "region"
}

variable "env" {
  description = "environment"
}

variable "network_remote_state_bucket" {
  description = "bucket"
}

variable "network_remote_state_key" {
  description = "network key"
}

variable "bastion_remote_state_bucket" {
  description = "bucket"
}

variable "bastion_remote_state_key" {
  description = "bastion key"
}

variable "instance_type" {
  description = "instance type"
}

variable "database_pass" {
  description = "redis password"
}
