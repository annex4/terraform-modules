output "arn" {
  value = aws_lambda_function.this.arn
}

output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.this.invoke_arn
}

output "role_id" {
    value = aws_iam_role.this.id
}

output "role_name" {
    value = aws_iam_role.this.name
}