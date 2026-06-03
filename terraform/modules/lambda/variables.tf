variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role for the Lambda function"
  type        = string
}

variable "handler" {
  description = "The handler for the Lambda function"
  type        = string
  default     = "lambda-function.lambda_handler"
}

variable "runtime" {
  description = "The runtime for the Lambda function"
  type        = string
  default     = "python3.9"
}

variable "source_file" {
  description = "The path to the source file for the Lambda function"
  type        = string
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  type        = string
}
