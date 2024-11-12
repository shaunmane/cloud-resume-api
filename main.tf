terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.0"
    }
  }
  cloud {
    organization = "ExamPro"
    workspaces {
      name = "terra-house-1"
    }
  }
}

# Cloud Provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# IAM role with all required permissions
resource "aws_iam_role" "resume_role" {
  name = "resume_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction"
        ],
        "Resource" : "arn:aws:lambda:*:*:function:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        "Resource" : "arn:aws:dynamodb:*:*:table/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:log-group:/aws/lambda/*"
      }
    ]
  })
}

# Upload the Lambda function
resource "aws_lambda_function" "create_function" {
  filename      = "./src/lambda_function.zip" # Path to the Lambda function ZIPPED file
  function_name = "lambda_function"
  role          = aws_iam_role.resume_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
}

# Create a REST API in API Gateway
resource "aws_api_gateway_rest_api" "resume_api" {
  name        = "ResumeApi"
  description = "API Gateway for Cloud Resume API Challenge"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "resumeResource" {
  rest_api_id = aws_api_gateway_rest_api.resume_api.id
  parent_id   = aws_api_gateway_rest_api.resume_api.root_resource_id
  path_part   = "myresumeresource"
}

# Define a Get method for the root resource
resource "aws_api_gateway_method" "resumeMeth" {
  rest_api_id   = aws_api_gateway_rest_api.resume_api.id
  resource_id   = aws_api_gateway_resource.resumeResource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Intergrate API Gateway with Lambda
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.resume_api.id
  resource_id             = aws_api_gateway_resource.resumeResource.id
  http_method             = aws_api_gateway_method.resumeMeth.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create_function.invoke_arn
}

# API Gateway to invoke lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.resume_api.execution_arn}/*/*"
}

# Deploy Rest API
resource "aws_api_gateway_deployment" "api_deploy" {
  depends_on  = [aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.resume_api.id


  lifecycle {
    create_before_destroy = true
  }
}

# Stage Rest API 
resource "aws_api_gateway_stage" "resume_stage" {
  deployment_id = aws_api_gateway_deployment.api_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.resume_api.id
  stage_name    = "resume_stage"
}

