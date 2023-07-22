# Create S3 Bucket
resource "aws_s3_bucket" "tf_backend" {
  bucket = var.bucket_name
  # bucket_prefix = "AWSLogs"
  tags = {
    Name    = var.bucket_name
    Managed = "tf-managed"
  }
}