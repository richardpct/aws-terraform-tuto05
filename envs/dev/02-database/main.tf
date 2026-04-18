module "database" {
  source                      = "../../../modules/database"
  aws_profile                 = var.aws_profile
  region                      = var.region
  env                         = "dev"
  network_remote_state_bucket = var.bucket
  network_remote_state_key    = var.key_network
  bastion_remote_state_bucket = var.bucket
  bastion_remote_state_key    = var.key_bastion
  instance_type               = "t2.micro"
  database_pass               = var.dev_database_pass
}
