output "bucket_name" {
  value = var.bucket_name
}

output "transfer_server_id" {
  value = aws_transfer_server.this.id
}

output "transfer_server_endpoint" {
  value = aws_transfer_server.this.endpoint
}
