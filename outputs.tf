output "api_gateway_url" {
  value = module.lambdas.api_gateway_url
}

output "user_pool_id" {
  value = module.cognito.user_pool_id
}

output "user_pool_client_id" {
  value = module.cognito.user_pool_client_id
}

output "phone_images_bucket_name" {
  description = "Name of the S3 bucket for phone images"
  value = module.s3.phone_images_bucket_name
}

output "phone_images_public_base_url" {
  description = "Base public URL for accessing phone images"
  value       = "https://${module.s3.phone_images_bucket_name}.s3.amazonaws.com"
}