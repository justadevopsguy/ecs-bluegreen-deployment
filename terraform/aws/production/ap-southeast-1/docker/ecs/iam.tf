resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${local.app_name}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = merge(local.default_tags, {
    Name = "${local.app_name}-iam-role"
  })
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy_document" "param_store" {
  statement {
    actions = [
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameterHistory",
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:ap-southeast-1:182155805005:parameter/production/mongodb/*",
    ]
  }

}
resource "aws_iam_policy" "param_store" {
  name        = "ecs-ecs-param-store"
  description = "Provides parameters read access"
  policy      = data.aws_iam_policy_document.param_store.json
  tags        = local.default_tags
}

resource "aws_iam_role_policy_attachment" "param_store_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = aws_iam_policy.param_store.arn
}