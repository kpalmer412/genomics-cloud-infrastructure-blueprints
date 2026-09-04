# 1. Secure Storage Infrastructure
resource "aws_s3_bucket" "genomic_data" {
  bucket        = "${var.organization}-${var.environment}-raw-fastq-data"
  force_destroy = true

  tags = {
    Organization = var.organization
    Environment  = var.environment
    CostCenter   = "Lab-Operations"
  }
}

# 2. Automatic Glacier Archiving Policy
resource "aws_s3_bucket_lifecycle_configuration" "archive_policy" {
  bucket = aws_s3_bucket.genomic_data.id

  rule {
    id     = "archive-old-fastq-files"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}
