data "terraform_remote_state" "vpc_database" {
  backend = "s3"
  config = {
    bucket  = "ajq-terraform"
    key     = "aws/production/ap-southeast-1/network/vpc/ecs-production.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
    profile = "aj-ecs"
  }
}


data "aws_vpc" "ecs_vpc" {
  id = local.vpc_id
}
