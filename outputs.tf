output "api_gateway_url" {
  value = module.lambdas.api_gateway_url
}

output "user_pool_id" {
  value = module.cognito.user_pool_id
}

output "user_pool_client_id" {
  value = module.cognito.user_pool_client_id
}
