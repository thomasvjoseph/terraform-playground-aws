terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }
  }

  backend "s3" {
    bucket         = "ems-remote-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-remote-state-dynamo"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}