# AWS SNS Module

resource "aws_sns_topic" "this" {
  name         = var.topic_name
  display_name = var.display_name != "" ? var.display_name : var.topic_name
  tags         = var.tags
}

resource "aws_sns_topic_subscription" "this" {
  count     = length(var.subscribers)
  topic_arn = aws_sns_topic.this.arn
  protocol  = var.protocol
  endpoint  = var.subscribers[count.index]
}
