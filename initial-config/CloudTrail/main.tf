#ToDo:  Add CloudTrail integration with CloudWatch Logs
#ToDo:  Add S3 bucket access logging

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_cloudtrail" "cloudtrail" {
  name = "default-trail"
  s3_bucket_name = "${aws_s3_bucket.cloudtrail-bucket.bucket}"
  include_global_service_events = true
  is_multi_region_trail = true
}

resource "aws_s3_bucket" "cloudtrail-bucket" {
  bucket = "${var.bucket_name}"
  force_destroy = true
  policy = "${data.aws_iam_policy_document.cloudtrail-bucket-policy.json}"
}

data "aws_iam_policy_document" "cloudtrail-bucket-policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = ["s3:GetBucketAcl"]
    resources = ["${format("arn:aws:s3:::%s","${var.bucket_name}")}"]
  }
  statement {
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = ["s3:PutObject"]
    resources = ["${format("arn:aws:s3:::%s/*","${var.bucket_name}")}"]
    condition {
      test = "StringEquals"
      values = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }
}