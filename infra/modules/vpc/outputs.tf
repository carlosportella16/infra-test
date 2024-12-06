output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = [for s in values(aws_subnet.public) : s.id]
}

output "private_subnets" {
  value = [for s in values(aws_subnet.private) : s.id]
}
