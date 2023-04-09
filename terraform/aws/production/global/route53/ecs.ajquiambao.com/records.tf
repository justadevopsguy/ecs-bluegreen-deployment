resource "aws_route53_record" "ecs_alb" {
  zone_id = aws_route53_zone.ecs_ajq.zone_id
  name    = "tha.${local.domain}"
  type    = "CNAME"
  records = ["ecs-production-alb-914748128.ap-southeast-1.elb.amazonaws.com"]
  ttl     = 60
}