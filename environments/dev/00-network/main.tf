terraform {
  backend "s3" {}
}

module "network" {
  source = "../../../modules/network"

  region                = "eu-west-3"
  env                   = "dev"
  vpc_cidr_block        = "10.0.0.0/16"
  subnet_public_nat     = "10.0.0.0/24"
  subnet_public_bastion = "10.0.1.0/24"
  subnet_public_web     = "10.0.2.0/24"
  subnet_private        = "10.0.3.0/24"
  cidr_allowed_ssh      = var.my_ip_address
}
