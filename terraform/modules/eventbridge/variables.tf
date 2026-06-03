variable "rule_name" {
  description = "The name of the EventBridge rule"
  type        = string
}

variable "lambda_function_arn" {
  description = "The ARN of the Lambda function to trigger"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function to trigger"
  type        = string
}

variable "event_pattern" {
  description = "The event pattern for the EventBridge rule"
  type        = string
}
