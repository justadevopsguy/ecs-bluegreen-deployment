locals {
  domain = "ecs.ajquiambao.com"
}

resource "aws_route53_zone" "ecs_ajq" {
  name = local.domain

  tags = {
    "TFProject" = "github.com/justadevopsguy/ecs-tha//terraform/aws/production/global/route53/ecs.ajquiambao.com",
    "Owner"     = "ajq",
    "ManagedBy" = "terraform"
  }
}