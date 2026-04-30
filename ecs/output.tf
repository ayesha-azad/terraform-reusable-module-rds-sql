output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.dns_name
}

output "app_url" {
  description = "URL to access the application"
  value       = "http://${module.alb.dns_name}"
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = module.alb.target_groups["ecs-task"].arn
}