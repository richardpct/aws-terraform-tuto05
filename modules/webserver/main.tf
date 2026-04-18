data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    profile = var.aws_profile
    bucket  = var.network_remote_state_bucket
    key     = var.network_remote_state_key
    region  = var.region
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"

  config = {
    profile = var.aws_profile
    bucket  = var.bastion_remote_state_bucket
    key     = var.bastion_remote_state_key
    region  = var.region
  }
}

data "terraform_remote_state" "database" {
  backend = "s3"

  config = {
    profile = var.aws_profile
    bucket  = var.database_remote_state_bucket
    key     = var.database_remote_state_key
    region  = var.region
  }
}

data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [137112412989] # amazon owner id
}

resource "aws_launch_template" "web" {
  name          = "web"
  image_id      = data.aws_ami.amazonlinux.id
  user_data     = base64encode(templatefile("${path.module}/user-data.sh", { environment   = var.env,
                                                                             database_host = data.terraform_remote_state.database.outputs.database_private_ip,
                                                                             database_pass = var.database_pass }))
  instance_type = var.instance_type
  key_name      = data.terraform_remote_state.bastion.outputs.ssh_key

  network_interfaces {
    subnet_id                   = data.terraform_remote_state.network.outputs.subnet_public_web_id
    security_groups             = [data.terraform_remote_state.network.outputs.sg_webserver_id]
    associate_public_ip_address = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "web" {
  launch_template {
    id = aws_launch_template.web.id
  }

  tags = {
    Name = "web_server-${var.env}"
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = {
    Name = "eip_web-${var.env}"
  }
}
