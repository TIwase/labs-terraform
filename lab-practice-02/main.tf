
# VPC, Subnet, SG作成
module "create_vpcs" {
  source            = "./modules/aws-createVpcs/"
  vpc_name_tag      = "labtest-vpc-01"
  vpc_cidr          = "172.32.0.0/16"
  subnet_name_tag   = "labtest-subnet-01"
  subnet_cidr       = "172.32.1.0/24"
  subnet_az         = "ap-northeast-1c"
}
# キーペア作成
module "create_keypair" {
  source            = "./modules/aws-createKeyPair"
  keypair_name      = "labtest-keypair-01"
}
# インスタンス作成
module "create_instance" {
  source            = "./modules/aws-createEc2"
  instance_type     = "t2.micro"
  root_volume_type  = "gp2"
  root_volume_size  = 10
  instance_name_tag = "labtest-username-02"
}