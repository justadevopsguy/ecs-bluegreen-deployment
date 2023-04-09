output "zone_name" {
  description = "Name of the Route53 Zone"
  value       = aws_route53_zone.ecs_ajq.name
}

output "zone_id" {
  description = "Zone ID of the Route53 Zone"
  value       = aws_route53_zone.ecs_ajq.zone_id
}

output "name_servers" {
  description = "List of name servers of the Route53 Zone"
  value       = aws_route53_zone.ecs_ajq.name_servers
}