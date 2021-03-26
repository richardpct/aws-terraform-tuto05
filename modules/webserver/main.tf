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

data "terraform_remote_state" "bastion" {
  backend = "s3"

  config = {
    bucket = var.bastion_remote_state_bucket
    key    = var.bastion_remote_state_key
    region = var.region
  }
}

data "terraform_remote_state" "database" {
  backend = "s3"

  config = {
    bucket = var.database_remote_state_bucket
    key    = var.database_remote_state_key
    region = var.region
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    environment   = var.env
    database_host = data.terraform_remote_state.database.outputs.database_private_ip
    database_pass = var.database_pass
  }
}

resource "aws_instance" "web" {
  ami                    = var.image_id
  user_data              = data.template_file.user_data.rendered
  instance_type          = var.instance_type
  key_name               = data.terraform_remote_state.bastion.outputs.ssh_key
  subnet_id              = data.terraform_remote_state.network.outputs.subnet_public_web_id
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.sg_webserver_id]

  tags = {
    Name = "web_server-${var.env}"
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  vpc      = true

  tags = {
    Name = "eip_web-${var.env}"
  }
}
