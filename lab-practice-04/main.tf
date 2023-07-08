
# VPC, Subnet, SG作成
module "create_vpcs" {
  source            = "./modules/aws-createVpcs/"
  vpc_name_tag      = var.vpc_name_tag_str
  vpc_cidr          = var.vpc_cidr_str
  subnet_name_tag   = var.subnet_name_tag_str
  subnet_cidr       = var.subnet_cidr_str
  subnet_az         = var.subnet_az_str
}
# キーペア作成
module "create_keypair" {
  source            = "./modules/aws-createKeyPair"
  keypair_name      = var.keypair_name_str
}
# インスタンス作成
module "create_instance" {
  source            = "./modules/aws-createEc2"
  instance_type     = var.instance_type_str
  keypair_name      = module.create_keypair.name
  root_volume_type  = var.root_volume_type_str
  root_volume_size  = var.root_volume_size_num
  instance_name_tag = var.instance_name_tag_str
  depends_on = [ module.create_vpcs ] # module単体での実行の場合、本行をコメントアウトすること
}
