resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = "projectbucket2023"
}
resource "aws_dynamodb_table" "my_dynamo_table" {
    name = "project-dynamo"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type = "S"
    }
}