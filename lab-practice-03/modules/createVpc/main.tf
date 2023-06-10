# Get S3 Bucket 
data "aws_s3_bucket" "selected" {
  provider = aws.dest_acct
  bucket = var.bucket_name
}
# Create VPC
resource "aws_vpc" "test" {
  provider = aws.src_acct
  cidr_block           = var.vpc_cidr
  tags = {
    Name    = var.vpc_name
    Managed = "tf-managed"
  }
}

# Logging to S3 Bucket
resource "aws_flow_log" "test" {
  provider = aws.src_acct
  log_destination      = data.aws_s3_bucket.selected.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.test.id
  depends_on           = [ aws_vpc.test ]
}
