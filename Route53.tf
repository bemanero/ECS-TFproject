
# resource "aws_route53_record" "web-elearning" {
#   zone_id = data.aws_route53_zone.project.zone_id
#   name    = "web.${data.aws_route53_zone.project.name}"
#   type    = var.aws_route53_record_type

#   alias {
#     name                   = module.ECS.application_load_balancer_dns_name
#     zone_id                = module.ECS.application_load_balancer_zone_id
#     evaluate_target_health = true
#   }
# }

# resource "aws_acm_certificate" "cert" {
#   domain_name       = data.aws_route53_zone.project.name
#   validation_method = "DNS"


#   lifecycle {
#     create_before_destroy = true
#   }
# }