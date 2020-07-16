/**
 * Terraform module to create a aws transfer server (SFTP).
 * 
 * This project is a fork of [Felipe Frizzo's module](https://github.com:felipefrizzo/terraform-aws-transfer-server).
 * 
 * ## Usage
 * 
 * ```hcl
 * resource "aws_s3_bucket" "bucket" {
 *   bucket = "bucket_name"
 *   acl    = "private"
 * }
 * 
 * module "sftp" {
 *    source = "git:https://github.com/bergbrains/terraform-aws-transfer-server.git?ref=master"
 * 
 *   transfer_server_name  = "sftp-server-name"
 *   transfer_server_users = { eberg = "SSH public key", user2 = "SSH public key"}
 *   bucket_name           = aws_s3_bucket.bucket.id
 *   bucket_arn            = aws_s3_bucket.bucket.arn
 *   additional_tags       = { client = var.client, environment = var.environment }
 * }
 * ```
 *
 * */

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

  server_id  = aws_transfer_server.this.id
  user_name  = each.key
  body       = lookup(var.transfer_server_users, each.key, null)
  depends_on = [aws_transfer_user.this]
}
