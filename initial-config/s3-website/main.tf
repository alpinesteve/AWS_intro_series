provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_s3_bucket" "demo-website-bucket" {
  bucket = "${var.website_bucket_name}"
  acl = "public-read"
  website {
    index_document = "index.html"
    error_document = "nope.html"
  }
  policy = "${data.aws_iam_policy_document.demo-website-bucket-policy.json}"
}

data "aws_iam_policy_document" "demo-website-bucket-policy" {
  "statement" {
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type = "*"
    }
    actions = ["s3:GetObject"]
    resources = ["${format("arn:aws:s3:::%s/*","${var.website_bucket_name}")}"]
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket = "${aws_s3_bucket.demo-website-bucket.id}"
  key = "index.html"
  source = "index.html"
  etag = "${md5(file("index.html"))}"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error" {
  bucket = "${aws_s3_bucket.demo-website-bucket.id}"
  key = "nope.html"
  source = "nope.html"
  etag = "${md5(file("nope.html"))}"
  content_type = "text/html"
}