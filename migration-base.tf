resource "aws_security_group" "migration_sg" {
  provider = aws.seoul
  name     = "Migration-Access-SG"
  vpc_id   = module.kor_vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.onprem_private_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "migration_target_bucket" {
  provider = aws.seoul
  bucket   = "migration-video-data-${random_id.bucket_id.hex}" # 고유한 버킷명 생성
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_iam_role" "datasync_s3_role" {
  provider = aws.seoul
  name     = "DataSync-S3-Access-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "datasync.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "datasync_s3_policy" {
  provider = aws.seoul
  name     = "DataSync-S3-Policy"
  role     = aws_iam_role.datasync_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.migration_target_bucket.arn
      },
      {
        Action = [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListMultipartUploadParts",
          "s3:PutObject",
          "s3:Tagging"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.migration_target_bucket.arn}/*"
      }
    ]
  })
}
