output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public1.id
}

output "private_subnet_id" {
  value = aws_subnet.private1.id
}

output "external_lb_dns" {
  value = aws_lb.ext_alb.dns_name
}

output "internal_lb_dns" {
  value = aws_lb.int_alb.dns_name
}
