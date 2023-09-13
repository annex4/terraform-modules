output "user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "identity_pool_id" {
  value = aws_cognito_identity_pool.this.id
}

output "admin_lambda_arn" {
  value = module.admin_function.arn
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.this.id
}

output "user_lambda_arn" {
  value = module.user_function.arn
}

output "authenticated_role_name" {
    value = module.user_roles.authenticated_role_name
}