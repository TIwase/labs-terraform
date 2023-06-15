
# S3バケット作成(マスターアカウント側)
module "create_bucket" {
  source            = "./modules/createS3bucket/"
  bucket_name       = var.bucket_name_str
  providers = {
    aws.dest_acct = aws.master
    aws.src_acct  = aws.member
  }
}
# VPC及びフローログ作成(メンバーアカウント側)
module "create_vpcs" {
  source            = "./modules/createVpc/"
  vpc_cidr          = var.vpc_cidr_str
  vpc_name          = var.vpc_name_str
  bucket_name       = var.bucket_name_str
  depends_on        = [ module.create_bucket ] # module単体での実行の場合、本行をコメントアウトすること
  providers = {
    aws.dest_acct = aws.master
    aws.src_acct  = aws.member
  }
}
