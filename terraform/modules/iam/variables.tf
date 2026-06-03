variable "role_name" {
  description = "The name of the IAM role for the Lambda function"
  type        = string
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic the Lambda function will publish to"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy for the Lambda function"
  type        = string
}
