variable "region" {
  type = string
}

variable "vpc-sg" {
  type = object({
    name                = string
    description         = string
    ingress_cidr_blocks = list(string)
    ingress_rules       = list(string)
  })
}

variable "rds-config" {
  type = object({
    identifier                          = string
    engine                              = string
    engine_version                      = string
    instance_class                      = string
    allocated_storage                   = number
    db_name                             = string
    username                            = string
    port                                = string
    iam_database_authentication_enabled = bool
    tag-owner                           = string
    tag-env                             = string
    family                              = string
    major_engine_version                = string
  })
}

variable "db_snapshot_identifier" {
  type = string
}