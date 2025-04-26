module "iam" {
  source = "./modules/iam"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "lambdas" {
  source           = "./modules/lambdas"
  lambda_role_arn  = module.iam.lambda_exec_role_arn
  customers_table  = module.dynamodb.customers_table_name
  inventory_table = module.dynamodb.inventory_table_name
}

module "cognito" {
  source = "./modules/cognito"
}

module "s3" {
  source = "./modules/s3"
}

