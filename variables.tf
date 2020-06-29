variable "additional_tags" {
  description = "Tags to be added to the default tag"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "The S3 bucket name"
  type        = string
}

variable "bucket_arn" {
  description = "The S3 bucket arn"
  type        = string
}

variable "transfer_server_name" {
  description = "Transfer Server name"
  type        = string
}

variable "transfer_server_users" {
  description = "Map, keyed on user name, where the value is the SSH public key, for SFTP server"
  type        = map(string)
}
