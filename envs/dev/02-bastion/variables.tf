variable "aws_profile" {
  description = "aws profile"
}

variable "region" {
  description = "region"
}

variable "key_network" {
  description = "key network"
}

variable "bucket" {
  description = "bucket where OpenTofu states are stored"
}

variable "key_bastion" {
  description = "key bastion"
}

variable "ssh_public_key" {
  description = "ssh public key"
}
