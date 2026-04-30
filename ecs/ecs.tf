module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = var.alb_name
  vpc_id  = var.vpc_id
  subnets = var.subnet_ids

  enable_deletion_protection = true

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = var.vpc_cidr
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "ecs-task"
      }
    }
  }

  target_groups = {
    ecs-task = {
      name_prefix       = var.target_group_name_prefix
      protocol          = "HTTP"
      port              = var.container_port
      target_type       = "ip"
      create_attachment = false

      health_check = {
        enabled             = true
        healthy_threshold   = 2
        unhealthy_threshold = 3
        timeout             = 5
        interval            = 30
        path                = "/"
        matcher             = "200-399"
      }
    }
  }

  tags = var.tags
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = var.cluster_name

  cluster_capacity_providers         = var.cluster_capacity_providers
  default_capacity_provider_strategy = var.default_capacity_provider_strategy

  services = {
    ecsdemo-frontend = {
      cpu    = var.service_cpu
      memory = var.service_memory

      container_definitions = {
        main = {
          cpu       = var.container_cpu
          memory    = var.container_memory
          essential = true
          image     = var.container_image

          portMappings = [
            {
              name          = var.container_name
              containerPort = var.container_port
              protocol      = "tcp"
            }
          ]

          readonlyRootFilesystem = false
          memoryReservation      = var.container_memory_reservation
        }
      }

      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["ecs-task"].arn
          container_name   = "main"
          container_port   = var.container_port
        }
      }

      subnet_ids       = var.subnet_ids
      assign_public_ip = true

      security_group_ingress_rules = {
        alb_traffic = {
          description                  = "Allow traffic from ALB"
          from_port                    = var.container_port
          to_port                      = var.container_port
          ip_protocol                  = "tcp"
          referenced_security_group_id = module.alb.security_group_id
        }
      }

      security_group_egress_rules = {
        all_internet = {
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    }
  }

  tags = var.tags
}