# IAM role with lambda required permissions
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowAssumeRole",
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : [
            "lambda.amazonaws.com",
            "dynamodb.amazonaws.com"
          ]
        }
      }
    ]
  })
}

# Policy for running lambda
resource "aws_iam_policy" "execution_policy" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
    {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid": "AllowLambda",
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction"
        ],
        "Resource" : "arn:aws:lambda:*:*:function:*"
      },
      {
        "Sid": "AllowDynamoDB",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        "Resource" : "arn:aws:dynamodb:*:*:table/*"
      },
      {
        "Sid": "AllowCloudWatch",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      }
    ]
  }
  EOF
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.execution_policy.arn
}

# Upload the Lambda function
resource "aws_lambda_function" "create_function" {
  filename      = "${path.module}/src/lambda_function.zip" # Path to the Lambda function ZIPPED file
  function_name = "lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
}

# Cloud watch log group for lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/create_function"
  retention_in_days = 14
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
  stage_name    = "prod"
}

