resource "aws_cognito_user_pool" "retail_users" {
  name = "RetailUserPool"

  auto_verified_attributes = ["email"]

  schema {
    name     = "email"
    required = true
    mutable  = true
    attribute_data_type = "String"
    developer_only_attribute = false
  }

  password_policy {
    minimum_length    = 6
    require_uppercase = false
    require_numbers   = false
    require_symbols   = false
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_cognito_user_pool_client" "frontend_app" {
  name         = "RetailFrontendApp"
  user_pool_id = aws_cognito_user_pool.retail_users.id

  generate_secret = false
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers = ["COGNITO"]

  callback_urls = ["http://localhost:5173/after-login"]
  logout_urls   = ["http://localhost:5173/"]

  allowed_oauth_flows       = ["code"]
  allowed_oauth_scopes      = ["email", "openid", "profile"]
  explicit_auth_flows       = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
}
