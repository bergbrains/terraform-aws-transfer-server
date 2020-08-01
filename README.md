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

  transfer_server_name  = "sftp-server-name"
  transfer_server_users = { eberg = "SSH public key", user2 = "SSH public key"}
  bucket_name           = aws_s3_bucket.bucket.id
  bucket_arn            = aws_s3_bucket.bucket.arn
  additional_tags       = { client = var.client, environment = var.environment }
}
```

\*/

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tags | Tags to be added to the default tag | `map(string)` | `{}` | no |
| bucket\_arn | The S3 bucket arn | `string` | n/a | yes |
| bucket\_name | The S3 bucket name. | `string` | n/a | yes |
| transfer\_server\_name | Transfer Server name | `string` | n/a | yes |
| transfer\_server\_users | Map, keyed on user name, where the value is the SSH public key, for SFTP server | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | n/a |
| transfer\_server\_endpoint | n/a |
| transfer\_server\_id | n/a |

