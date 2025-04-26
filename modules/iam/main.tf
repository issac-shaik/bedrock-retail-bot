resource "aws_iam_role" "bedrock_agent_role" {
  name = "BedrockAgentRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "bedrock.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "bedrock_agent_policy" {
  name = "BedrockAgentPolicy"
  role = aws_iam_role.bedrock_agent_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "LambdaExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "LambdaDynamoDBPolicy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem"
        ],
        Resource = "arn:aws:dynamodb:ap-south-1:774305573467:table/Customers"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_update_policy" {
  name = "LambdaUpdatePolicy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:UpdateItem"
        ],
        Resource = "arn:aws:dynamodb:ap-south-1:774305573467:table/Customers"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_inventory_access" {
  name = "LambdaInventoryAccessPolicy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:Scan",
          "dynamodb:GetItem"
        ],
        Resource = [
          "arn:aws:dynamodb:ap-south-1:774305573467:table/Customers",
          "arn:aws:dynamodb:ap-south-1:774305573467:table/Inventory"
        ]
      }
    ]
  })
}
