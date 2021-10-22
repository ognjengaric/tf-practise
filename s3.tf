resource "aws_s3_bucket" "bucket" {
  bucket = "bucket-${random_string.suffix.result}"
  acl    = "private"

  versioning {
    enabled = true
  }
}

