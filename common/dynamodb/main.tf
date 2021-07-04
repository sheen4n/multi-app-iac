resource "aws_dynamodb_table" "this" {
  name         = "${var.app_name}-${var.environment}-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  global_secondary_index {
    name            = "InvertedIndex"
    hash_key        = "SK"
    range_key       = "PK"
    projection_type = "ALL"
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}"
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "2"

    actions = [
      "dynamodb:List*",
      "dynamodb:DescribeReservedCapacity*",
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive"
    ]

    resources = [
      "arn:aws:dynamodb:::*",
    ]
  }

  statement {
    actions = [
      "dynamodb:BatchGet*",
      "dynamodb:DescribeStream",
      "dynamodb:DescribeTable",
      "dynamodb:Get*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWrite*",
      "dynamodb:CreateTable",
      "dynamodb:Delete*",
      "dynamodb:Update*",
      "dynamodb:PutItem"
    ]

    resources = [
      aws_dynamodb_table.this.arn,
      "${aws_dynamodb_table.this.arn}/*",
    ]
  }
}


resource "aws_iam_policy" "this" {
  name   = "${var.app_name}-${var.environment}-dynamodb-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.this.json
}
