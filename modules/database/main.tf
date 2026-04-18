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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*ubuntu-noble-24.04-amd64-minimal-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # ubuntu owner id
}

resource "aws_launch_template" "database" {
  name          = "database"
  image_id      = data.aws_ami.ubuntu.id
  user_data     = base64encode(templatefile("${path.module}/user-data.sh", { database_pass = var.database_pass }))
  instance_type = var.instance_type
  key_name      = data.terraform_remote_state.bastion.outputs.ssh_key

  network_interfaces {
    subnet_id                   = data.terraform_remote_state.network.outputs.subnet_private_id
    security_groups             = [data.terraform_remote_state.network.outputs.sg_database_id]
    associate_public_ip_address = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "database" {
  launch_template {
    id = aws_launch_template.database.id
  }

  tags = {
    Name = "database-${var.env}"
  }
}
