resource "aws_s3_bucket" "example" {
  bucket = "your-unique-bucket-name" 
  tags = {
    Name        = "Demo"
    Environment = "MyEnv"
    Owner       = "Amit"
  }
}