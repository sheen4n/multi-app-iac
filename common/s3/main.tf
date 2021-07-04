resource "aws_s3_bucket" "this" {
  bucket = "${var.app_name}-${var.environment}-bucket"
  acl    = "private"

  tags = {
    Name        = "${var.app_name}-${var.environment}-bucket"
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.this.arn,
    ]
  }

  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "this" {
  name   = "${var.app_name}-${var.environment}-s3-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.this.json
}
