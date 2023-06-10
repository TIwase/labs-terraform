# Create S3 Bucket
resource "aws_s3_bucket" "flow_log" {
  provider = aws.dest_acct
  bucket = var.bucket_name
  # bucket_prefix = "AWSLogs"
  tags = {
    Name    = var.bucket_name
    Managed = "tf-managed"
  }
}
# Block Public Access to this Bucket
resource "aws_s3_bucket_public_access_block" "enabled" {
  provider = aws.dest_acct
  bucket = aws_s3_bucket.flow_log.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on = [ aws_s3_bucket.flow_log ]
}
# Create Bucket Policy
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  provider = aws.dest_acct
  bucket = aws_s3_bucket.flow_log.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  depends_on = [ aws_s3_bucket.flow_log ]
}

data "aws_caller_identity" "source_account" {
  provider = aws.src_acct
}
data "aws_caller_identity" "dest_acctination_account" {
  provider = aws.dest_acct
}
data "aws_region" "current" {}
data "aws_iam_policy_document" "allow_access_from_another_account" {
  # provider = aws.dest_acct
  statement {
    sid = "AWSLogDeliveryWrite"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.flow_log.arn}",
      "${aws_s3_bucket.flow_log.arn}/*",
    ]
    condition {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
    condition {
      test = "StringEquals"
      variable = "aws:SourceAccount"
      values = ["${data.aws_caller_identity.source_account.account_id}"]
    }
    condition {
      test = "ArnLike"
      variable = "aws:SourceArn"
      values = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.source_account.account_id}:*"]
    }
  }
  statement {
    sid = "AWSLogDeliveryCheck"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.flow_log.arn}",
      "${aws_s3_bucket.flow_log.arn}/*",
    ]
    condition {
      test = "StringEquals"
      variable = "aws:SourceAccount"
      values = ["${data.aws_caller_identity.source_account.account_id}"]
    }
    condition {
      test = "ArnLike"
      variable = "aws:SourceArn"
      values = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.source_account.account_id}:*"]
    }
  }
}