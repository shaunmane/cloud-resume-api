import json
import boto3
from botocore.exceptions import ClientError

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Resumes')

def dynamodb_to_json(dynamodb_data):
    """
    Recursively converts DynamoDB JSON format to normal JSON.
    """
    if isinstance(dynamodb_data, dict):
        # Check if the data contains the DynamoDB types and handle them accordingly
        if 'S' in dynamodb_data:
            return dynamodb_data['S']
        elif 'M' in dynamodb_data:
            # Recursively process the map
            return {key: dynamodb_to_json(value) for key, value in dynamodb_data['M'].items()}
        elif 'L' in dynamodb_data:
            # Recursively process the list
            return [dynamodb_to_json(item) for item in dynamodb_data['L']]
        else:
            # If no recognized format, return the data as is
            return dynamodb_data
    else:
        # If it's not a dictionary, return the value directly (e.g., a string, number, etc.)
        return dynamodb_data

def lambda_handler(event, context):
    # Get the resume ID from the path parameters (assuming it's part of the URL, e.g., /resume/{id})
    resume_id = event.get('id', '1')
    
    if not resume_id:
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps({'message': 'Missing resume ID in the request'})
        }
    
    try:
        # Fetch the item from DynamoDB using the resume ID
        response = table.get_item(
            Key={'id': resume_id}  # 'id' is the partition key for the Resumes table
        )
        
        # Check if the item was found
        if 'Item' not in response:
            return {
                'statusCode': 404,
                'headers': {
                    'Content-Type': 'application/json'
                },
                'body': json.dumps({'message': f'Resume with ID {resume_id} not found'})
            }

        # Convert the DynamoDB JSON format to normal JSON
        resume_data = dynamodb_to_json(response['Item'])

        # Return the converted resume data as JSON
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps(resume_data)
        }

    except ClientError as e:
        # Handle any DynamoDB client errors
        print(e.response['Error']['Message'])
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps({'message': 'Failed to fetch resume data', 'error': e.response['Error']['Message']})
        }

