terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.42.0"
    }
  }
}

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc-config.cidr_block 
  tags = {
    Name = var.vpc-config.vpc-name
  }
}

resource "aws_subnet" "private-subnet" {
  for_each = var.private-subnets
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability-zone
  tags = {
    Name = each.value.subnet-name
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_route_table_association" "rtb-assoc" {
  for_each = var.private-subnets
  subnet_id = aws_subnet.private-subnet[each.key].id
  route_table_id = aws_route_table.route-table.id
}

resource "aws_security_group" "rds-sg" {
  name = var.security-group-config.security-group-name
  description = var.security-group-config.security-group-description
  vpc_id = aws_vpc.my-vpc.id

  ingress {
    cidr_blocks = [ var.private-subnets["private-subnet-1"].cidr_block ]
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
    from_port = 0
    to_port = 0
  }

  tags = {
    Name = var.security-group-config.security-group-name
  }
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  subnet_ids = [ aws_subnet.private-subnet["private-subnet-1"].id, aws_subnet.private-subnet["private-subnet-2"].id]
}

resource "aws_db_instance" "rds-mysql" {
    allocated_storage = var.rds-mysql-config.allocated_storage 
    db_name = var.rds-mysql-config.db_name 
    engine = var.rds-mysql-config.engine 
    engine_version = var.rds-mysql-config.engine_version  
    instance_class = var.rds-mysql-config.instance_class 
    username = var.rds-mysql-config.username 
    password = var.rds-mysql-config.password 
    parameter_group_name = var.rds-mysql-config.parameter_group_name  
    skip_final_snapshot = var.rds-mysql-config.skip_final_snapshot
    multi_az = var.rds-mysql-config.multi_az

    vpc_security_group_ids = [ aws_security_group.rds-sg.id ]
    db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.name
}

resource "aws_db_snapshot" "rds-sql-snapshot" {
    depends_on = [ aws_db_instance.rds-mysql ]
  db_instance_identifier = aws_db_instance.rds-mysql.identifier
  db_snapshot_identifier = var.db_snapshot_identifier
}