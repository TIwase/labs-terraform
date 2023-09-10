output "instance_id" {
  value = aws_instance.demo.id
}
output "instance_priv_ip" {
  value = aws_instance.demo.private_ip
}
# output "root_volume_id" {
#   value = aws_instance.demo.root_block_device
# }