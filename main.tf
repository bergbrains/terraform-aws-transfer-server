/*
 This module creates an AWS Transfer Family SFTP server.

 #

 */

# ToDo: change to using map of users and key

resource "aws_transfer_server" "this" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = aws_iam_role.transfer_server.arn

  tags = merge(
    var.additional_tags,
    map(
      "Name", var.transfer_server_name
    )
  )
}

resource "aws_transfer_user" "this" {
  for_each = var.transfer_server_users

  server_id      = aws_transfer_server.this.id
  user_name      = each.key
  role           = aws_iam_role.transfer_server.arn
  home_directory = "/${var.bucket_name}"

  tags = merge(
    var.additional_tags,
    map(
      "Name", each.key
    )
  )
}

resource "aws_transfer_ssh_key" "this" {
  for_each = var.transfer_server_users

  server_id = aws_transfer_server.this.id
  user_name = each.key
  body      = lookup(var.transfer_server_users, each.key, null)
  depends_on = [aws_transfer_user.this]
}
