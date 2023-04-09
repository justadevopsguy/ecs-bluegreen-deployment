resource "aws_vpc" "production" {
  cidr_block           = local.cidr_block
  enable_dns_hostnames = true

  tags = merge(local.default_tags, {
    Name = "ecs-${local.environment}"
  })
}
