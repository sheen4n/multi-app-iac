locals {
  all_group_names = toset(["dev_developers", "dev_interns", "prod_developers", "administrator_group"])
  region          = "ap-southeast-1"
}

provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  region                  = local.region
}

resource "aws_iam_group" "iam_group" {
  for_each = local.all_group_names
  name     = each.value
}

module "example_app_dev" {
  source = "./example_app_dev"
}

module "example_app_prod" {
  source = "./example_app_prod"
}
