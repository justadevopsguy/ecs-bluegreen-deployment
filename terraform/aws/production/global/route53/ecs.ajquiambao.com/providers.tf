terraform {
  required_version = "= 1.3.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.5.0"
    }
  }

  backend "s3" {
    bucket         = "ajq-terraform"
    key            = "aws/production/global/route53/ecs.ajquiambao.com.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "ajq-terraform-lock"
    profile        = "aj-ecs"
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "aj-ecs"
}