### Get Latest AmazonLinux2 AMI
data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
# Get subnet ID
data "aws_subnet" "selected" {
  filter {
    name   = "tag:Managed"
    values = ["tf-managed"]
  }
}
# Get Security Group ID
data "aws_security_groups" "selected" {
  filter {
    name   = "tag:Managed"
    values = ["tf-managed"]
  }
}
# Get Key Pair Name
data "aws_key_pair" "selected" {
  filter {
    name   = "tag:Managed"
    values = ["tf-managed"]
  }
}
### Create ENI
# resource "aws_network_interface" "primary_eni" {
#   subnet_id                   = var.InstanceSubnetID
#   private_ips                 = [var.InstancePriIP]
#   security_groups             = [var.InstanceSGID]
#   tags = {
#     Name                  = format("%s-eni", var.InstanceTagName)
#     Managed               = var.TAG_MANAGED
#   }
# }

### Run EC2 Instance
resource "aws_instance" "demo" {
  ami                    = data.aws_ssm_parameter.amzn2_ami.value
  instance_type          = var.InstanceType
  key_name               = data.aws_key_pair.selected.key_name
  subnet_id              = data.aws_subnet.selected.id
  vpc_security_group_ids = data.aws_security_groups.selected.ids
  # network_interface {
  #   network_interface_id = aws_network_interface.primary_eni.id
  #   device_index         = 0
  # }
  root_block_device {
    volume_type          = var.RootVolumeType
    volume_size          = var.RootVolumeSize
  }

  instance_initiated_shutdown_behavior = "terminate"
  tags = {
    Name                 = var.InstanceTagName
    Managed              = var.TAG_MANAGED
  }
  # depends_on = [
  #   aws_network_interface.primary_eni
  # ]
}