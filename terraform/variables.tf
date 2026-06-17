variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "route53-dns-monitoring"
}

variable "role_name" {
  description = "The name of the IAM role for the Lambda function"
  type        = string
  default     = "route53-dns-monitoring-role"
}

variable "policy_name" {
  description = "The name of the IAM policy for the Lambda function"
  type        = string
  default     = "route53-dns-monitoring-policy"
}

variable "sns_topic_name" {
  description = "The name of the SNS topic to create"
  type        = string
  default     = "route53-dns-monitoring-topic"
}

variable "sns_subscription_email" {
  description = "The email address for SNS subscription"
  type        = string
  default     = "temp.banwait.1@gmail.com"
}

variable "event_rule_name" {
  description = "The name of the EventBridge rule"
  type        = string
  default     = "route53-dns-monitoring-rule"
}
