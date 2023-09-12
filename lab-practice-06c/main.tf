# VPC, Subnet, SG作成
module "create_vpcs" {
  source            = "./modules/aws-createVpcs/"
  vpc_name_tag      = var.vpc_name_tag_str
  vpc_cidr          = var.vpc_cidr_str
  # subnet_name_tag   = var.subnet_name_tag_str
  # subnet_cidr       = var.subnet_cidr_str
  # subnet_az         = var.subnet_az_str
}

