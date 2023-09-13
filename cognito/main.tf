resource "aws_cognito_user_pool" "this" {
  name = var.user_pool_name

  mfa_configuration = "OPTIONAL"

  username_attributes = ["email"]

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    temporary_password_validity_days = 7
  }

  user_pool_add_ons {
    advanced_security_mode = "OFF"
  }

  lambda_config {
    post_confirmation = module.post_signup_hook_function.arn
  }

  software_token_mfa_configuration {
    enabled = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  schema {
    name                     = "company"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 128
    }
  }

  //depends_on = [module.cognito_functions]
}

resource "aws_cognito_user_pool_client" "this" {
  name = var.user_pool_client_name

  user_pool_id = aws_cognito_user_pool.this.id

  // TODO: Set appropriate links for S3/Cloudfront
  callback_urls = ["localhost:8080/oauth/login", "localhost:8081/oauth/login", "localhost:8082/oauth/login"]
  logout_urls   = ["localhost:8080/oauth/logout", "localhost:8081/oauth/logout", "localhost:8082/oauth/logout"]

  allowed_oauth_flows  = ["code"]
  allowed_oauth_scopes = ["phone", "email", "profile", "openid"]

  explicit_auth_flows = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_CUSTOM_AUTH"]

  enable_token_revocation = true

  prevent_user_existence_errors = "ENABLED"

  read_attributes = [
    "address",
    "email",
    "family_name",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]

  write_attributes = [
    "address",
    "email",
    "family_name",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]
}

resource "aws_cognito_identity_pool" "this" {
  identity_pool_name               = var.identity_pool_name
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.this.id
    provider_name           = aws_cognito_user_pool.this.endpoint
    server_side_token_check = false
  }
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = var.prefix
  user_pool_id = aws_cognito_user_pool.this.id
}