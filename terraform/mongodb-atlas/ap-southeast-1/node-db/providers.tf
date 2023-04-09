terraform {
  required_version = "= 1.3.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.5.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.8.1"
    }
  }

  backend "s3" {
    bucket         = "ajq-terraform"
    key            = "mongodb-atlas/ap-southeast-1/ecs-db.tfstate"
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

data "aws_ssm_parameter" "mongodb_pubic_token" {
  name = "/production/mongodb/public_keytoken"
}

data "aws_ssm_parameter" "mongodb_private_token" {
  name = "/production/mongodb/private_keytoken"
}


provider "mongodbatlas" {
  public_key  = data.aws_ssm_parameter.mongodb_pubic_token.value
  private_key = data.aws_ssm_parameter.mongodb_private_token.value
}