# Bucket作成
# module "create_bucket" {
#   source            = "./modules/aws-createBucket/"
#   bucket_name       = var.s3_bucket_name_str
# }

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
  bucket_name       = var.s3_bucket_name_str
  instance_type     = var.instance_type_str
  keypair_name      = module.create_keypair.name
  subnet_id         = module.create_vpcs.subnet_id
  sg_id             = module.create_vpcs.sg_id
  root_volume_type  = var.root_volume_type_str
  root_volume_size  = var.root_volume_size_num
  instance_name_tag = var.instance_name_tag_str
}
