locals {
  alb_access_logs_enabled = false
  alb_target_port         = 3000
  app                     = "example"
  availability_zone       = "eu-west-1a"
  name_prefix             = "${local.app}-${var.env}-"
}

module "alb_ec2" {
  source = "../../../../modules/alb_ec2_with_data_volume"

  alb_internal       = false
  alb_subnet_ids     = data.aws_subnets.alb.ids
  alb_target_port    = local.alb_target_port
  app                = local.app
  availability_zone  = local.availability_zone
  env                = var.env
  instance_ami       = data.aws_ami.this.id
  instance_subnet_id = one(data.aws_subnets.instance.ids)
  vpc_id             = data.aws_vpc.this.id

  tags = {
    app = local.app
  }
}
