module "sns" {
  source = "./modules/sns"

  topic_name    = var.sns_topic_name
  email_address = var.sns_subscription_email
}

module "iam" {
  source = "./modules/iam"

  role_name     = var.role_name
  policy_name   = var.policy_name
  sns_topic_arn = module.sns.topic_arn
}

module "lambda" {
  source = "./modules/lambda"

  function_name = var.function_name
  role_arn      = module.iam.role_arn
  sns_topic_arn = module.sns.topic_arn
  source_file   = "${path.module}/../lambda-function.py"
}

module "eventbridge" {
  source = "./modules/eventbridge"

  rule_name            = var.event_rule_name
  lambda_function_arn  = module.lambda.lambda_arn
  lambda_function_name = module.lambda.lambda_function_name
  event_pattern        = file("${path.module}/../event-bridge-rule-pattern.json")
}
