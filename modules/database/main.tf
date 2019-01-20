provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "${var.network_remote_state_bucket}"
    key    = "${var.network_remote_state_key}"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"

  config {
    bucket = "${var.bastion_remote_state_bucket}"
    key    = "${var.bastion_remote_state_key}"
    region = "${var.region}"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars = {
    database_pass = "${var.database_pass}"
  }
}

resource "aws_instance" "database" {
  ami                    = "${var.image_id}"
  user_data              = "${data.template_file.user_data.rendered}"
  instance_type          = "${var.instance_type}"
  key_name               = "${data.terraform_remote_state.bastion.ssh_key}"
  subnet_id              = "${data.terraform_remote_state.network.subnet_private_id}"
  vpc_security_group_ids = ["${data.terraform_remote_state.network.sg_database_id}"]

  tags {
    Name = "database_server-${var.env}"
  }
}
