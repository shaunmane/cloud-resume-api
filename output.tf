# Output the API endpoint URL
output "api_endpoint" {
  value = aws_api_gateway_rest_api.resume_api.execution_arn
}

output "api_gateway_endpoint" {
  value = "https://${aws_api_gateway_rest_api.resume_api.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.resume_stage.stage_name}/${aws_api_gateway_resource.resumeResource.path_part}"
}
