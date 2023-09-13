data "aws_iam_policy_document" "logging" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:PutRetentionPolicy"
    ]

    resources = [
      "arn:aws:logs:${var.region}:${var.account}:log-group:/aws/lambda/${aws_lambda_function.this.function_name}:log-stream:*"
    ]
  }
}

resource "aws_iam_role_policy" "logging" {
  name   = "${aws_lambda_function.this.function_name}-logging"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.logging.json
}

resource "aws_cloudwatch_log_group" "logging" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 7
  depends_on        = [aws_lambda_function.this]
}