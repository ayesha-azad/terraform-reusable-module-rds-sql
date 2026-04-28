variable "region" {
  type = string
}

variable "vpc-config" {
  type = object({
    name               = string
    cidr_block         = string
    azs                = list(string)
    private_subnets    = list(string)
    enable_nat_gateway = bool
    enable_vpn_gateway = bool
    terraform-tag      = string
    env-tag            = string
  })
}

variable "vpc-sg" {
  type = object({
    name        = string
    description = string 

    ingress_cidr_blocks = list(string)
    ingress_rules       = list(string)
    ingress_with_cidr_blocks = list(object({
       from_port   = number
        to_port     = number
        protocol    = string 
        description = string
        cidr_blocks = string 
    }))
    egress_with_cidr_blocks = list(object({
       from_port   = number
        to_port     = number
        protocol    = string 
        description = string
        cidr_blocks = string 
    }))
  })

}

variable "rds-config" {
  type = object({
    identifier        = string
    engine            = string
    engine_version    = string
    instance_class    = string
    allocated_storage = number
    db_name  = string
    username = string
    port     = string
    iam_database_authentication_enabled = bool
    tag-owner = string 
    tag-env = string 
    create_db_subnet_group = bool
    family = string
    major_engine_version = string 
  })
}

variable "db_snapshot_identifier" {
  type = string 
}