data "aws_iam_policy_document" "transfer_server_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "transfer_server_assume" {
  statement {
    sid = "AllowListingFolders"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    effect = "Allow"
    resources = [
      var.bucket_arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:List*",
      "s3:DeleteObjectVersion",
      "s3:DeleteObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "${var.bucket_arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "transfer_server_to_cloudwatch_assume" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "transfer_server" {
  name               = "${var.transfer_server_name}-transfer_server"
  assume_role_policy = data.aws_iam_policy_document.transfer_server_assume_role.json
  tags = merge(
    var.additional_tags,
    map(
      "Name", var.transfer_server_name
    )
  )
}

resource "aws_iam_role_policy" "transfer_server" {
  name   = "${var.transfer_server_name}-transfer_server"
  role   = aws_iam_role.transfer_server.name
  policy = data.aws_iam_policy_document.transfer_server_assume.json
}

resource "aws_iam_role_policy" "transfer_server_to_cloudwatch" {
  name   = "${var.transfer_server_name}-transfer_server_to_cloudwatch"
  role   = aws_iam_role.transfer_server.name
  policy = data.aws_iam_policy_document.transfer_server_to_cloudwatch_assume.json
}