resource "aws_ecr_repository" "ecs_ecr" {
  name = "${local.app_name}/tha"
  tags = {
    Name        = "${local.app_name}-ecr"
    Environment = local.environment
  }
}