module "iam" {
  source = "./modules/iam"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}
