terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.65.0"
    }
  }
  cloud {
    organization = "lab-practice-04/main.tf"

    workspaces {
      name = "labs-terraform"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region     = "ap-northeast-1"
}
