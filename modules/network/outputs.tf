output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_public_nat_id" {
  value = aws_subnet.public_nat.id
}

output "subnet_public_bastion_id" {
  value = aws_subnet.public_bastion.id
}

output "subnet_public_web_id" {
  value = aws_subnet.public_web.id
}

output "subnet_private_id" {
  value = aws_subnet.private.id
}

output "sg_bastion_id" {
  value = aws_security_group.bastion.id
}

output "sg_database_id" {
  value = aws_security_group.database.id
}

output "sg_webserver_id" {
  value = aws_security_group.webserver.id
}
