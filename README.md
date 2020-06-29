# terraform-aws-transfer-server

Terraform module to create a aws transfer server (SFTP).

This project is a fork of [Felipe Frizzo's module](https://github.com:felipefrizzo/terraform-aws-transfer-server).

## Usage

```hcl
resource "aws_s3_bucket" "bucket" {
  bucket = "bucket_name"
  acl    = "private"
}

module "sftp" {
   source = "git:https://github.com/bergbrains/terraform-aws-transfer-server.git?ref=master"

  transfer_server_name       = "sftp-server-name"
  transfer_server_users   = { eberg = "SSH public key", user2 = "SSH public key"}
  bucket_name                = aws_s3_bucket.bucket.id
  bucket_arn                 = aws_s3_bucket.bucket.arn
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| bucket_name | S3 bucket name | string | `` | yes |
| bucket_arn | S3 bucket arn | string | `` | yes |
| transfer_server_name | Transfer Server name | string | `` | yes |
| transfer_server_users | Map of user names to SSH public key. | list(string) | `` | yes |
