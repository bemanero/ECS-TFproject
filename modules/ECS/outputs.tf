
output "application_load_balancer_dns_name" {
  value = "${aws_lb.ecs_alb.dns_name}"
}
output "application_load_balancer_zone_id" {
  value = "${aws_lb.ecs_alb.zone_id}"
}