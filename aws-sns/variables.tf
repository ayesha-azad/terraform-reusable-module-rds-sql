variable "region" {
  type = string
}

variable "publisher-role-config" {
  type = object({
    create_role = bool
    role_name = string 
    role_requires_mfa = bool 
    trusted_role_arns = list(string)
    custom_role_policy_arns = list(string)
  })
}

variable "sqs-config" {
  type = object({
    name = string
    fifo_queue = bool 
    tags = object({
      Environment = string 
    })
  })
}

variable "sns-config" {
  type = object({
    name                        = string
    fifo_topic                  = bool
    content_based_deduplication = bool
    topic_policy_statements = object({
      pub = object({
        actions = list(string)
        principals = list(object({
          type        = string
          identifiers = list(string)
        }))
      })
      sub = object({
        actions = list(string)
        principals = list(object({
          type        = string
          identifiers = list(string)
        }))
        conditions = list(object({
          test     = string
          variable = string
          values   = list(string)
        }))
      })
    })
    subscriptions = object({
      sqs = object({
        protocol = string
        endpoint = string
      })
    })
    tags = object({
      Environment = string
      Terraform   = string
    })
  })
}