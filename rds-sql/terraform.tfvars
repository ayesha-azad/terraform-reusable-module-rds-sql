region = "eu-north-1"

vpc-sg = {
  name        = "new-sg"
  description = "This is a new vpc."

  ingress_cidr_blocks = ["10.10.0.0/16"]
  ingress_rules       = ["https-443-tcp"]
}

rds-config = {
  identifier                          = "mydb"
  engine                              = "mysql"
  engine_version                      = "8.4"
  instance_class                      = "db.r7g.large"
  allocated_storage                   = 5
  db_name                             = "mydb"
  username                            = "admin"
  port                                = "3306"
  iam_database_authentication_enabled = true
  tag-owner                           = "user"
  tag-env                             = "dev"
  family                              = "mysql8.4"
  major_engine_version                = "8.4"
}

db_snapshot_identifier = "rds-snapshot"