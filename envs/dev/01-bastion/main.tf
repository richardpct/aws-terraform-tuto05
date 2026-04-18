module "bastion" {
  source                      = "../../../modules/bastion"
  aws_profile                 = var.aws_profile
  region                      = "eu-west-3"
  env                         = "dev"
  network_remote_state_bucket = var.bucket
  network_remote_state_key    = var.key_network
  instance_type               = "t2.micro"
  ssh_public_key              = var.ssh_public_key
}
