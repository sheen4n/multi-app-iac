locals {
  user_groups = ["prod_developers", "administrator_group"]
  app_name    = "example-app"
  environment = "prod"
}


module "example_app_dev_s3_bucket" {
  source      = "../common/s3"
  app_name    = local.app_name
  environment = local.environment
}

module "example_app_dev_dynamodb_bucket" {
  source      = "../common/dynamodb"
  app_name    = local.app_name
  environment = local.environment
}

# module "iam_group_policy_attachment" {
#   source      = "../common/iam_group_policy_attachment"
#   group_names = local.user_groups
#   policy_arns = [module.example_app_dev_s3_bucket.s3_policy_arn, module.example_app_dev_dynamodb_bucket.dynamodb_policy_arn]
# }
