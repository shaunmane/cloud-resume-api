# Cloud Resume API Challenge with AWS

[![Deploy to lambda](https://github.com/shaunmane/cloud-resume-api/actions/workflows/deploy.yml/badge.svg)](https://github.com/shaunmane/cloud-resume-api/actions/workflows/deploy.yml)

A serverless API (that serves resume data in JSON format) using AWS Lambda and DynamoDB, integrated with GitHub Actions.

## Services Used

- **AWS DynamoDB**: Stores sample resume data.

- **AWS Lambda**: Fetches and returns resume data based on an id.

- **AWS API Gateway**: Makes the Resume API accessible over the internet.

- **GitHub Actions**: Automatically packages and deploys the resources on every push to the repository.

- **Terraform**: For infrastructure as code.

## API Resume Link

```
curl https://292djl6bck.execute-api.us-east-1.amazonaws.com/prod/myresumeresource 
```

## MIT License

![License](https://img.shields.io/badge/license-MIT-green)