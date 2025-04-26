variable "lambda_role_arn" {
  type = string
}

variable "customers_table" {
  type = string
}

variable "inventory_table" {
  description = "Inventory table"
  type        = string
}
