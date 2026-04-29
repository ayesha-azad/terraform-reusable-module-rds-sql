data "aws_vpc" "existing-vpc" {
  
}

module "security-group" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.3.1"
  name        = var.vpc-sg.name
  description = var.vpc-sg.description
  vpc_id      = data.aws_vpc.existing-vpc.id

  ingress_cidr_blocks = var.vpc-sg.ingress_cidr_blocks
  ingress_rules       = var.vpc-sg.ingress_rules

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Ingress Rules for vpc"
      cidr_blocks = "10.3.0.0/16"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Egress Rules for vpc"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  identifier        = var.rds-config.identifier
  engine            = var.rds-config.engine
  engine_version    = var.rds-config.engine_version
  instance_class    = var.rds-config.instance_class
  allocated_storage = var.rds-config.allocated_storage

  db_name  = var.rds-config.db_name
  username = var.rds-config.username
  port     = var.rds-config.port

  iam_database_authentication_enabled = var.rds-config.iam_database_authentication_enabled

  vpc_security_group_ids = [module.security-group.security_group_id]

  tags = {
    Owner       = var.rds-config.tag-owner
    Environment = var.rds-config.tag-env
  }

  family               = var.rds-config.family
  major_engine_version = var.rds-config.major_engine_version
}

resource "aws_db_snapshot" "rds-snapshot" {
  depends_on = [module.rds]

  db_instance_identifier = module.rds.db_instance_identifier
  db_snapshot_identifier = var.db_snapshot_identifier
}