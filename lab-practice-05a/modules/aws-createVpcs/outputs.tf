output "vpc_arn" {
  value = aws_vpc.test.arn
}
output "vpc_id" {
  value = aws_vpc.test.id
}
output "vpc_route_table_id" {
  value = aws_vpc.test.main_route_table_id
}
output "subnet_arn" {
  value = aws_subnet.subnet_apne1c.arn
}
output "subnet_az_id" {
  value = aws_subnet.subnet_apne1c.availability_zone_id
}
output "subnet_id" {
  value = aws_subnet.subnet_apne1c.id
}
output "sg_arn" {
  value = aws_security_group.allow_traffic.arn
}
output "sg_id" {
  value = aws_security_group.allow_traffic.id
}
