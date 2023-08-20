#!/bin/bash

cd terraform
# Prompt user for AWS access key ID and secret access key
read -s -p "Enter your AWS Access Key ID: " AWS_ACCESS_KEY_ID
echo
read -s -p "Enter your AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
echo

# Create a temporary file to store AWS credentials
echo $AWS_ACCESS_KEY_ID > aws_credentials.tmp
echo $AWS_SECRET_ACCESS_KEY >> aws_credentials.tmp

# Run Terraform commands
terraform init
terraform apply -auto-approve -var="aws_access_key=$(cat aws_credentials.tmp | head -n 1)" -var="aws_secret_key=$(cat aws_credentials.tmp | tail -n 1)" -var="git_commit_sha=$(./get_commit_sha.sh)"

# deletion of the file storing sensitive credentials
rm -f aws_credentials.tmp