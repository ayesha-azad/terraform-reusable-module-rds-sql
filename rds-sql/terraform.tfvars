region     = "eu-north-1"

vpc-config = {
  name               = "my-vpc"  
  cidr_block         = "10.0.0.0/16"
  azs                = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_nat_gateway = false 
  enable_vpn_gateway = false 
  terraform-tag      = "true"
  env-tag            = "dev"
}

vpc-sg = {
    name        = "new-sg"
  description = "This is a new vpc."

  ingress_cidr_blocks = ["10.10.0.0/16"]
  ingress_rules       = ["https-443-tcp"]
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

rds-config = {
  identifier        = "mydb"
    engine            = "mysql"
    engine_version    = "8.4.8"
    instance_class    = "t3.micro"
    allocated_storage = 5
    db_name  = "mydb"
    username = "admin"
    port     = "3306"
    iam_database_authentication_enabled = true
    tag-owner = "user"
    tag-env = "dev"
    create_db_subnet_group = false
    family = "mysql8.4.8"
    major_engine_version = "8.4.8" 
}

db_snapshot_identifier = "rds-snapshot"