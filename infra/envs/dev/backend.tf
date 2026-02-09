terraform {
  # TODO: Configure remote state (S3 + DynamoDB) when ready.
  # backend "s3" {
  #   bucket         = "myshop-terraform-state"
  #   key            = "envs/dev/terraform.tfstate"
  #   region         = "ap-southeast-2"
  #   dynamodb_table = "myshop-terraform-locks"
  #   encrypt        = true
  # }
}
