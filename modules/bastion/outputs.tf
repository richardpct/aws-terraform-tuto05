output "bastion_public_ip" {
  value = aws_eip.bastion.public_ip
}

output "ssh_key" {
  value = aws_key_pair.deployer.key_name
}
