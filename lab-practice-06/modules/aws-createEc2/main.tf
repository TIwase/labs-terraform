### Get Latest AmazonLinux2 AMI
data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
# Get subnet ID
# data "terraform_remote_state" "s3" {
#   backend = "s3"
#   config = {
#     bucket = var.bucket_name
#     key    = "./terraform.tfstate"
#     region = "ap-northeast-1"
#   }
# }
# Get Security Group ID
# data "aws_security_groups" "selected" {
#   filter {
#     name   = "tag:Managed"
#     values = ["tf-managed"]
#   }
# }
# Get Key Pair Name
# data "aws_key_pair" "selected" {
#   filter {
#     name   = "tag:Managed"
#     values = ["tf-managed"]
#   }
# }

data "template_file" "user_data" {
  template = "${file("./modules/aws-createEc2/user_data.tpl")}"
}
### Run EC2 Instance
resource "aws_instance" "demo" {
  ami                    = data.aws_ssm_parameter.amzn2_ami.value
  instance_type          = var.instance_type
  key_name               = var.keypair_name
  # key_name               = data.aws_key_pair.selected.key_name
  # subnet_id              = data.terraform_remote_state.s3.outputs.vpcs_output_all.subnet_id
  subnet_id              = var.subnet_id
  # vpc_security_group_ids = data.aws_security_groups.selected.ids
  vpc_security_group_ids = [ var.sg_id ]
  user_data              = data.template_file.user_data.rendered

  root_block_device {
    volume_type          = var.root_volume_type
    volume_size          = var.root_volume_size
  }

  instance_initiated_shutdown_behavior = "terminate"
  tags = {
    Name                 = var.instance_name_tag
    Managed              = "tf-managed"
  }

}