resource "aws_lambda_function" "get_customer" {
  function_name = "getCustomerFunction"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = var.lambda_role_arn
  filename      = "${path.module}/../../get_customer.zip"
 
  layers        = [aws_lambda_layer_version.aws_sdk_layer.arn]
  source_code_hash = filebase64sha256("${path.module}/../../get_customer.zip")
  environment {
    variables = {
      CUSTOMER_TABLE = var.customers_table
    }
  }
}

resource "aws_apigatewayv2_api" "http_api" {
  name          = "retail-bot-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["content-type"]
    max_age = 3600
  } 
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                = aws_apigatewayv2_api.http_api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = aws_lambda_function.get_customer.invoke_arn
  integration_method    = "POST"              
  payload_format_version = "2.0"
}


resource "aws_apigatewayv2_route" "get_customer_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /get_customer"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_customer.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_lambda_layer_version" "aws_sdk_layer" {
  filename             = "${path.module}/../../aws_sdk_layer_v2.zip"
  layer_name           = "aws-sdk-layer"
  compatible_runtimes = ["nodejs18.x", "nodejs20.x"]
  description          = "Provides aws-sdk for Lambda functions"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_function" "update_customer_traits" {
  function_name = "updateCustomerTraitsFunction"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = var.lambda_role_arn
  layers        = [aws_lambda_layer_version.aws_sdk_layer.arn]
  filename      = "${path.module}/../../update_customer_traits.zip"
  source_code_hash = filebase64sha256("${path.module}/../../update_customer_traits.zip")

  environment {
    variables = {
      CUSTOMER_TABLE = var.customers_table
    }
  }
}

resource "aws_apigatewayv2_integration" "update_traits_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.update_customer_traits.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "update_traits_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /update_customer_traits"
  target    = "integrations/${aws_apigatewayv2_integration.update_traits_integration.id}"
}

resource "aws_lambda_permission" "allow_api_gateway_update_traits" {
  statement_id  = "AllowExecutionFromAPIGatewayUpdateTraits"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_customer_traits.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_lambda_function" "get_inventory" {
  function_name = "getInventoryFunction"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = var.lambda_role_arn
  filename      = "${path.module}/../../get_inventory.zip"
  
  layers        = [aws_lambda_layer_version.aws_sdk_layer.arn] # ✅ Attach Layer Here
  source_code_hash = filebase64sha256("${path.module}/../../get_inventory.zip")

  environment {
    variables = {
      CUSTOMER_TABLE = var.customers_table
      INVENTORY_TABLE = var.inventory_table
    }
  }
}

resource "aws_apigatewayv2_integration" "get_inventory_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.get_inventory.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "get_inventory_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /get_inventory"
  target    = "integrations/${aws_apigatewayv2_integration.get_inventory_integration.id}"
}

resource "aws_lambda_permission" "allow_api_gateway_get_inventory" {
  statement_id  = "AllowExecutionFromAPIGatewayGetInventory"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_inventory.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
