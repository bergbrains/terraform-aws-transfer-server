resource "aws_transfer_server" "transfer_server" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = aws_iam_role.transfer_server.arn

  tags = merge(
    var.additional_tags,
    map(
      "Name", var.transfer_server_name
    )
  )
}

  count = length(var.transfer_server_user_names)
resource "aws_transfer_user" "this" {

  user_name      = element(var.transfer_server_user_names, count.index)
  server_id      = aws_transfer_server.this.id
  role           = aws_iam_role.transfer_server.arn
  home_directory = "/${var.bucket_name}"
  tags = merge(
    var.additional_tags,
    map(
      "Name", each.key
    )
  )
}

  count = length(var.transfer_server_user_names)
resource "aws_transfer_ssh_key" "this" {

  server_id = aws_transfer_server.transfer_server.id
  user_name = element(aws_transfer_user.transfer_server_user.*.user_name, count.index)
  body      = element(var.transfer_server_ssh_keys, count.index)
}
