terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.65.0"
      configuration_aliases = [ aws.src_acct, aws.dest_acct ]
    }
  }
}
provider "aws" {
  alias = "member"
  region = "ap-northeast-1"
  profile = "iwt-member-acct"   
}
provider "aws" {
  alias = "master"
  region = "ap-northeast-1"
  profile = "default"
}