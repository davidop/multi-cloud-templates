resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "private"
}

output "bucket_id" {
  value = aws_s3_bucket.this.id
}
