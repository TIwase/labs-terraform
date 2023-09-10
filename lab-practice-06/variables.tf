variable "s3_bucket_name_str" {}
variable "vpc_name_tag_str" {}
variable "vpc_cidr_str" {}
variable "subnet_name_tag_str" {}
variable "subnet_cidr_str" {}
variable "subnet_az_str" {}
variable "keypair_name_str" {}
variable "instance_type_str" {}
variable "root_volume_type_str" {}
variable "root_volume_size_num" {}
variable "instance_name_tag_str" {}
variable "tfc_aws_dynamic_credentials" {
  description = "Object containing AWS dynamic credentials configuration"
  type = object({
    default = object({
      shared_config_file = string
    })
    aliases = map(object({
      shared_config_file = string
    }))
  })
}
