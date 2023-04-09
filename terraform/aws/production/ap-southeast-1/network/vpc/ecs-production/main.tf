locals {
  cidr_block  = "10.20.0.0/20" #4094 hosts
  environment = "production"
  owner       = "team-ecs"

  default_tags = {
    Owner       = local.owner
    ManagedBy   = "terraform"
    Environment = local.environment
    TFProject   = "github.com/justadevopsguy/ecs-bluegreen-deployment//terraform/aws/production/ap-southeast-1/network/vpc/ecs-production"
  }

  availability_zones = [
    "ap-southeast-1a",
    "ap-southeast-1b",
    "ap-southeast-1c"
  ]

}