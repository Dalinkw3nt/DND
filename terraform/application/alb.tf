module "alb_web_logs_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                         = "alb-web-logs"
  acl                            = "log-delivery-write"
  force_destroy                  = true
  attach_elb_log_delivery_policy = true

  tags = local.common_tags
}

module "alb_app_logs_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                         = "alb-app-logs"
  acl                            = "log-delivery-write"
  force_destroy                  = true
  attach_elb_log_delivery_policy = true

  tags = local.common_tags
}

##################################

module "alb_web" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "alb-web"

  load_balancer_type = "application"

  vpc_id          = [data.terraform_remote_state.vpc.outputs.vpc_id][0]
  subnets         = [data.terraform_remote_state.vpc.outputs.public_subnets][0]
  security_groups = [data.terraform_remote_state.vpc.outputs.sg.sg_alb.security_group_id]

  access_logs = {
    bucket = "alb-web-logs"
  }

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        my_target_1 = {
          target_id = "${module.ec2_instance_web[0].id}"
          port      = 80
        }
        my_target_2 = {
          target_id = "${module.ec2_instance_web[1].id}"
          port      = 80
        }
        my_target_3 = {
          target_id = "${module.ec2_instance_web[2].id}"
          port      = 80
        }
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:acm:ca-central-1:12345678:certificate/123456-1234-1234-1234567890"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "example"
  }
}

###################################

module "alb_app" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "alb-app"

  load_balancer_type = "application"

  vpc_id          = [data.terraform_remote_state.vpc.outputs.vpc_id][0]
  subnets         = [data.terraform_remote_state.vpc.outputs.public_subnets][0]
  security_groups = [data.terraform_remote_state.vpc.outputs.sg.sg_alb.security_group_id]

  access_logs = {
    bucket = "alb-app-logs"
  }

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        my_target_1 = {
          target_id = "${module.ec2_instance_app[0].id}"
          port      = 80
        }
        my_target_2 = {
          target_id = "${module.ec2_instance_app[1].id}"
          port      = 80
        }
        my_target_3 = {
          target_id = "${module.ec2_instance_app[2].id}"
          port      = 80
        }
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:acm:ca-central-1:12345678:certificate/123456-1234-1234-1234567890"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "example"
  }
}

###################################