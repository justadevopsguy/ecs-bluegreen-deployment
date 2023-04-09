output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.production.id
}

output "vpc_cidr" {
  description = "The CIDR of the VPC"
  value       = aws_vpc.production.cidr_block
}


output "public_subnet_id" {
  description = "The ID of the Public Subnet"
  value       = aws_subnet.public_subnet.*.id
}

output "private_subnet_id" {
  description = "The ID of the Private Subnet"
  value       = aws_subnet.private_subnet.*.id
}