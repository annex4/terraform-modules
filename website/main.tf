/*resource "aws_iam_role" "website" {
  name = "${var.prefix}_role-${var.stage}"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "codepipeline.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "website" {
  name = "${var.prefix}_policy-${var.stage}"
  role = aws_iam_role.website.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect":"Allow",
        "Action": [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObjectAcl",
          "s3:PutObject"
        ],
        "Resource": [
          "${aws_s3_bucket.website.arn}",
          "${aws_s3_bucket.website.arn}/*"
        ]
      }
    ]
  })
}*/