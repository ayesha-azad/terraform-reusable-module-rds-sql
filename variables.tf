variable "region" {
  type = string
}

variable "vpc-config" {
  type = object({
    vpc-name = string 
    cidr_block = string 
  }) 
}

variable "private-subnets" {
    type = map(object({
      cidr_block = string 
      subnet-name = string
      availability-zone = string  
    }))
}

variable "security-group-config" {
  type = object({
    security-group-name = string 
    security-group-description = string 
  })
}

variable "rds-mysql-config" {
  type = object({
    allocated_storage = number 
    db_name = string 
    engine = string 
    engine_version = string  
    instance_class = string 
    username = string 
    password = string 
    parameter_group_name = optional(string, "")  
    skip_final_snapshot = bool
    multi_az = optional(bool, false) 
  })
}

variable "db_snapshot_identifier" {
  type = string 
}