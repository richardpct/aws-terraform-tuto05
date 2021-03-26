provider "aws" {
  region = var.region
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = var.network_remote_state_bucket
    key    = var.network_remote_state_key
    region = var.region
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-ssh-key-${var.env}"
  public_key = var.ssh_public_key
}

resource "aws_instance" "bastion" {
  ami                    = var.image_id
  user_data              = <<-EOF
                           #!/bin/bash
                           exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
                           sudo yum -y update
                           sudo yum -y upgrade
                           EOF
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = data.terraform_remote_state.network.outputs.subnet_public_bastion_id
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.sg_bastion_id]

  tags = {
    Name = "bastion-${var.env}"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = {
    Name = "eip_bastion-${var.env}"
  }
}
