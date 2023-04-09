locals {
  app_name    = "ecs"
  environment = "production"
  owner       = "team-ecs"
  vpc_id      = "vpc-007c09c0865798262"

  default_tags = {
    Owner       = local.owner
    ManagedBy   = "terraform"
    Environment = local.environment
    TFProject   = "github.com/justadevopsguy/ecs-bluegreen-deployment//terraform/aws/production/ap-southeast-1/network/vpc/ecs-production"
  }
}
