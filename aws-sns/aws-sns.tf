module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "3.0.0"

  create_role       = var.publisher-role-config.create_role
  role_name         = var.publisher-role-config.role_name
  role_requires_mfa = var.publisher-role-config.role_requires_mfa

  trusted_role_arns = var.publisher-role-config.trusted_role_arns

  custom_role_policy_arns = var.publisher-role-config.custom_role_policy_arns
}

module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "5.2.1"
  name    = var.sqs-config.name

  fifo_queue = var.sqs-config.fifo_queue

  tags = {
    Environment = var.sqs-config.tags.Environment
  }
}

module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "7.1.0"

  name                        = var.sns-config.name
  fifo_topic                  = var.sns-config.fifo_topic
  content_based_deduplication = var.sns-config.content_based_deduplication

  topic_policy_statements = {
    pub = {
      actions = var.sns-config.topic_policy_statements.pub.actions
      principals = [{
        type        = var.sns-config.topic_policy_statements.pub.principals[0].type
        identifiers = var.sns-config.topic_policy_statements.pub.principals[0].identifiers
      }]
    }

    sub = {
      actions = var.sns-config.topic_policy_statements.sub.actions
      principals = [{
        type        = var.sns-config.topic_policy_statements.sub.principals[0].type
        identifiers = var.sns-config.topic_policy_statements.sub.principals[0].identifiers
      }]

      conditions = [{
        test     = var.sns-config.topic_policy_statements.sub.conditions[0].test
        variable = var.sns-config.topic_policy_statements.sub.conditions[0].variable
        values   = var.sns-config.topic_policy_statements.sub.conditions[0].values
      }]
    }
  }

  subscriptions = {
    sqs = {
      protocol = var.sns-config.subscriptions.sqs.protocol
      endpoint = var.sns-config.subscriptions.sqs.endpoint
    }
  }

  tags = {
    Environment = var.sns-config.tags.Environment
    Terraform   = var.sns-config.tags.Terraform
  }
}
