output "bedrock_agent_role_arn" {
  value = aws_iam_role.bedrock_agent_role.arn
}

output "lambda_exec_role_arn" {
  value = aws_iam_role.lambda_exec_role.arn
}
