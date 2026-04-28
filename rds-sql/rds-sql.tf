module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"
  name    = var.vpc-config.name
  cidr    = var.vpc-config.cidr_block

  azs             = var.vpc-config.azs
  private_subnets = var.vpc-config.private_subnets

  enable_nat_gateway = var.vpc-config.enable_nat_gateway
  enable_vpn_gateway = var.vpc-config.enable_vpn_gateway

  tags = {
    Terraform   = var.vpc-config.terraform-tag
    Environment = var.vpc-config.env-tag
  }
}

module "security-group" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.3.1"
  name        = var.vpc-sg.name
  description = var.vpc-sg.description
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = var.vpc-sg.ingress_cidr_blocks
  ingress_rules       = var.vpc-sg.ingress_rules
  ingress_with_cidr_blocks = var.vpc-sg.ingress_with_cidr_blocks
  egress_with_cidr_blocks = var.vpc-sg.egress_with_cidr_blocks
}

module "rds" {
  source            = "terraform-aws-modules/rds/aws"
  version           = "7.2.0"
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
  create_db_subnet_group = var.rds-config.create_db_subnet_group
  subnet_ids             = module.vpc.private_subnets
  family = var.rds-config.family
  major_engine_version = var.rds-config.major_engine_version
}

resource "aws_db_snapshot" "rds-snapshot" {
    depends_on = [ module.rds ]
  db_instance_identifier = module.rds.db_instance_identifier
  db_snapshot_identifier = var.db_snapshot_identifier
}