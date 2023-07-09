terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.65.0"
    }
  }
  backend "s3" {
    bucket     = "labtest-backend-tfstate"
    key        = "./terraform.tfstate"
    region     = "ap-northeast-1"
  }
}
# Configure the AWS Provider
provider "aws" {
  region     = "ap-northeast-1"
}
