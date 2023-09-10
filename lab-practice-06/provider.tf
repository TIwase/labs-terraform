terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.65.0"
    }
  }
  cloud {
    organization = "iwaset-org"

    workspaces {
      name = "labs-terraform"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
  region              = "ap-northeast-1"
}
