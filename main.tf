module "my-rds-mysql" {
  source = "./module/rds"

  region = var.region

  vpc-config = var.vpc-config

  private-subnets = var.private-subnets

  security-group-config = var.security-group-config

  rds-mysql-config = var.rds-mysql-config

  db_snapshot_identifier = var.db_snapshot_identifier


}
