terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.68.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-test-access"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-remote-state-dynamo"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}