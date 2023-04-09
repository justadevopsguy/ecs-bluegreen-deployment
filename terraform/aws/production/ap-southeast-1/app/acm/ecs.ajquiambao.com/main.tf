locals {
  route53_hosted_zone_name = data.terraform_remote_state.route53_ajq.outputs.zone_name
  route53_hosted_zone_id   = data.terraform_remote_state.route53_ajq.outputs.zone_id
  default_tags = {
    Owner     = "ajq"
    ManagedBy = "terraform"
    "TFProject" = join("//", [
      "github.com/justadevopsguy/ecs-bluegreen-deployment",
      "terraform/aws/production/ap-southeast-1/app/acm/ecs.ajquiambao.com",
    ]),
  }
}

module "cert_ajq" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.3.2"

  domain_name = local.route53_hosted_zone_name
  zone_id     = local.route53_hosted_zone_id
  subject_alternative_names = [
    "*.${local.route53_hosted_zone_name}",
  ]
  tags = local.default_tags
}