data "aws_iam_policy_document" "policy" {
  statement {
    sid       = "website_policy-${var.stage}"
    actions   = ["s3:ListBucket", "s3:GetObject"]
    resources = [aws_s3_bucket.website.arn, "${aws_s3_bucket.website.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.website.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = data.aws_iam_policy_document.policy.json

  depends_on = [
    aws_s3_bucket.website
  ]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.id
  acl    = "private"

  depends_on = [ aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership ]
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket" "website" {
  bucket = var.sub_domain == "" ? "${var.domain_name}.io" : "${var.sub_domain}.${var.domain_name}.io"

  tags = {
    Name = var.prefix
  }
}
