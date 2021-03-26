output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "ssh_key" {
  value = module.bastion.ssh_key
}
