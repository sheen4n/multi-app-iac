locals {
  group_policies = [
    for group_policy in setproduct(var.group_names, var.policy_arns) : {
      group_name = group_policy[0]
      policy_arn = group_policy[1]
    }
  ]
}

resource "aws_iam_group_policy_attachment" "iam_group_policy_attachment" {
  for_each = {
    for group_policy in local.group_policies : "${group_policy.group_name}.${group_policy.policy_arn}" => group_policy
  }

  group      = each.value.group_name
  policy_arn = each.value.policy_arn
}
