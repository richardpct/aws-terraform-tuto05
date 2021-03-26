output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_public_nat_id" {
  value = module.network.subnet_public_nat_id
}

output "subnet_public_bastion_id" {
  value = module.network.subnet_public_bastion_id
}

output "subnet_public_web_id" {
  value = module.network.subnet_public_web_id
}

output "subnet_private_id" {
  value = module.network.subnet_private_id
}

output "sg_bastion_id" {
  value = module.network.sg_bastion_id
}

output "sg_database_id" {
  value = module.network.sg_database_id
}

output "sg_webserver_id" {
  value = module.network.sg_webserver_id
}
