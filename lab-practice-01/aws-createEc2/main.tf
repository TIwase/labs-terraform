### Get Latest AmazonLinux2 AMI
data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

### Create ENI
resource "aws_network_interface" "primary_eni" {
  subnet_id                   = var.InstanceSubnetID
  private_ips                 = [var.InstancePriIP]
  security_groups             = [var.InstanceSGID]
  tags = {
    Name                  = format("%s-eni", var.InstanceTagName)
    Managed               = var.TAG_MANAGED
  }
}
### Run EC2 Instance
resource "aws_instance" "demo" {
  ami                         = data.aws_ssm_parameter.amzn2_ami.value
  instance_type               = var.InstanceType
  key_name                    = var.InstanceKeypairName
#  associate_public_ip_address = var.InstancePubIPExists
  network_interface {
    network_interface_id = aws_network_interface.primary_eni.id
    device_index         = 0
  }
  root_block_device {
    volume_type          = var.RootVolumeType
    volume_size          = var.RootVolumeSize
  }
  tags = {
    Name                 = var.InstanceTagName
    Managed              = var.TAG_MANAGED
  }
  depends_on = [
    aws_network_interface.primary_eni
  ]
}