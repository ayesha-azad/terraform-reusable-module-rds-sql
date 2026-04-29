region = "eu-north-1"

publisher-role-config = {
  create_role       = true
  role_name         = "publisher"
  role_requires_mfa = false

  trusted_role_arns = [
    "arn:aws:iam::447150580332:root"
  ]

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
  ]
}

sqs-config = {
  name    = "subscriber"

  fifo_queue = true

  tags = {
    Environment = "dev"
  }
}

sns-config = {
  name = "new-topic"

  fifo_topic                  = true
  content_based_deduplication = true

  topic_policy_statements = {
    pub = {
      actions = ["sns:Publish"]
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::447150580332:role/publisher"]
      }]
    },

    sub = {
      actions = [
        "sns:Subscribe",
        "sns:Receive",
      ]

      principals = [{
        type        = "AWS"
        identifiers = ["*"]
      }]

      conditions = [{
        test     = "StringLike"
        variable = "sns:Endpoint"
        values   = ["arn:aws:sqs:eu-north-1:447150580332:subscriber.fifo"]
      }]
    }
  }

  subscriptions = {
    sqs = {
      protocol = "sqs"
      endpoint = "arn:aws:sqs:eu-north-1:447150580332:subscriber.fifo"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
