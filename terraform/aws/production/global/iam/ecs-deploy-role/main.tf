locals {
  ecs_deploy_iam_policy_attachments = [
    "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS",
  ]
}

data "aws_iam_policy_document" "ecs_deploy_role_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }

}

resource "aws_iam_role" "ecs_deploy_iam_role" {
  name               = "ecs-deploy-role"
  description        = "Code Deploy Role for ecs"
  assume_role_policy = data.aws_iam_policy_document.ecs_deploy_role_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_deploy_role_attachments" {
  for_each   = { for i in local.ecs_deploy_iam_policy_attachments : i => i }
  role       = aws_iam_role.ecs_deploy_iam_role.name
  policy_arn = each.key
}
