resource "aws_dynamodb_table" "customers" {
  name           = "Customers"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "customerId"

  attribute {
    name = "customerId"
    type = "S"
  }
}

resource "aws_dynamodb_table" "inventory" {
  name           = "Inventory"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "productId"

  attribute {
    name = "productId"
    type = "S"
  }
}
