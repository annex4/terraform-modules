data "aws_iam_policy_document" "lambda_access" {
    statement {
        actions = ["sts:AssumeRole"]
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        } 
    }
}

resource "aws_iam_role" "this" {
  name               = "lambda-${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_access.json
}