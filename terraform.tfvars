region = "eu-north-1"

vpc-config = {
  vpc-name = "my-vpc"
  cidr_block = "10.0.0.0/16"
}

private-subnets = {
    private-subnet-1 = {
        cidr_block = "10.0.1.0/24"
        subnet-name = "my-private-subnet"
        availability-zone = "eu-north-1a"
    }
    private-subnet-2 = {
        cidr_block = "10.0.2.0/24"
        subnet-name = "my-private-subnet"
        availability-zone = "eu-north-1b"
    }  
}

security-group-config = {
    security-group-name = "rds-sg" 
    security-group-description = "Allow inbound traffic only for MYSQL and all outbound traffic"
} 

rds-mysql-config = {
  allocated_storage = 10 
    db_name = "mydb"
    engine = "mysql" 
    engine_version = "8.4.8"  
    instance_class = "db.t3.micro"
    username = "admin"
    password = "password123"
    parameter_group_name = "" # optional  
    skip_final_snapshot = true
    multi_az = true # optional 
}

db_snapshot_identifier = "rds-mysql-db-snapshot" 