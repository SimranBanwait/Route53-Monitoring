output "lambda_arn" {
  description = "The ARN of the Lambda function"
  value       = module.lambda.lambda_arn
}

output "role_arn" {
  description = "The ARN of the IAM role"
  value       = module.iam.role_arn
}
