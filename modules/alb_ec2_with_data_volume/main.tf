
locals {
  name_prefix            = "${var.app}-${var.env}-"
  name                   = "${var.app}-${var.env}"
  alb_access_logs_prefix = coalesce(var.alb_access_logs_prefix, var.app)
  alb_ssl_listener       = var.alb_certificate_domain != ""
}

resource "aws_ebs_volume" "data" {
  count = var.data_volume_create ? 1 : 0

  availability_zone = var.availability_zone
  size              = var.data_volume_size
  type              = var.data_volume_type

  tags = merge(var.tags, {
    "Name" = local.name
  })
}

resource "aws_volume_attachment" "data_att" {
  count = var.data_volume_create ? 1 : 0

  device_name = var.data_volume_attachment_device_name
  volume_id   = aws_ebs_volume.data[0].id
  instance_id = aws_instance.this.id
}

resource "aws_iam_instance_profile" "this" {
  count = var.instance_associate_instance_profile ? 1 : 0

  name_prefix = local.name_prefix
  role        = var.iam_role_name

  tags = var.tags
}

resource "aws_instance" "this" {
  ami                  = var.instance_ami
  availability_zone    = var.availability_zone
  iam_instance_profile = one(aws_iam_instance_profile.this.*.id)
  instance_type        = var.instance_type
  key_name             = var.instance_key_name
  security_groups      = [module.instance_sg.security_group_id]
  subnet_id            = var.instance_subnet_id

  root_block_device {
    volume_size = var.root_volume_size

    tags = merge(var.tags, {
      "Name" = local.name
    })
  }

  tags = merge(var.tags, {
    "Name" = local.name
  })
}

resource "aws_lb" "this" {
  internal           = var.alb_internal
  load_balancer_type = "application"
  name_prefix        = substr(local.name_prefix, 0, 6)
  security_groups    = [module.alb_sg.security_group_id]
  subnets            = var.alb_subnet_ids

  access_logs {
    bucket  = var.alb_access_logs_bucket
    prefix  = local.alb_access_logs_prefix
    enabled = var.alb_access_logs_bucket != ""
  }

  tags = var.tags
}

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  vpc_id = var.vpc_id
  name   = local.name
  computed_egress_with_source_security_group_id = [{
    from_port                = var.alb_target_port
    to_port                  = var.alb_target_port
    protocol                 = "tcp"
    description              = "Load balancer to target"
    source_security_group_id = module.instance_sg.security_group_id
  }]
  number_of_computed_egress_with_source_security_group_id = 1

  tags = var.tags

}

module "instance_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  vpc_id = var.vpc_id
  name   = local.name
  computed_ingress_with_source_security_group_id = [{
    from_port                = var.alb_target_port
    to_port                  = var.alb_target_port
    protocol                 = "tcp"
    description              = "Load balancer to target"
    source_security_group_id = module.alb_sg.security_group_id
  }]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = var.tags
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.alb_listener_port
  protocol          = local.alb_ssl_listener ? "HTTPS" : "HTTP"
  certificate_arn   = local.alb_ssl_listener ? data.aws_acm_certificate.issued[0].arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = var.tags
}

resource "aws_lb_listener" "redirect_http" {
  count = var.alb_redirect_http ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = var.alb_listener_port
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  name_prefix = substr(local.name_prefix, 0, 6)
  port        = var.alb_target_port
  protocol    = var.alb_target_protocol
  vpc_id      = var.vpc_id

  health_check {
    path = var.alb_target_health_path
  }

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.this.id
  port             = var.alb_target_port
}
