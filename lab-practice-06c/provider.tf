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
      name = "ady19-labs-terraform"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region     = "ap-northeast-1"
}
