output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = values(aws_subnet.public[*].id)
}

output "private_subnets" {
  value = values(aws_subnet.private[*].id)
}
