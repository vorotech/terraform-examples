output "alb_sg_id" {
  value       = module.alb_sg.security_group_id
  description = "Security group associated with Application Load Balancer, can be referenced to add extra rules."
}

output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "Network load balancer DNS name."
}

output "alb_zone_id" {
  value       = aws_lb.this.zone_id
  description = "Network load balancer hosted zone ID."
}

output "alb_arn" {
  value       = aws_lb.this.arn
  description = "Network load balancer ARN."
}

output "instance_id" {
  value       = aws_instance.this.id
  description = "EC2 Instance."
}

output "instance_sg_id" {
  value       = module.instance_sg.security_group_id
  description = "Security group associated with EC2 Instance, can be referenced to add extra rules."
}
