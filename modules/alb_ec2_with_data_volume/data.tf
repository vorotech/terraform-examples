data "aws_acm_certificate" "issued" {
  count = local.alb_ssl_listener ? 1 : 0

  domain   = var.alb_certificate_domain
  statuses = ["ISSUED"]
}
