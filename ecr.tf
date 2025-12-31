# ==========================================
# 1. 서울 리전 (Seoul) ECR 레포지토리
# ==========================================
resource "aws_ecr_repository" "user" {
  provider             = aws.seoul
  name                 = "user-service"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "order" {
  provider             = aws.seoul
  name                 = "order-service"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "product" {
  provider             = aws.seoul
  name                 = "product-service"
  image_tag_mutability = "IMMUTABLE"
}

# ==========================================
# 2. 미국 오레곤 리전 (Oregon) ECR 레포지토리
# ==========================================
resource "aws_ecr_repository" "user_oregon" {
  provider             = aws.oregon
  name                 = "user-service"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "order_oregon" {
  provider             = aws.oregon
  name                 = "order-service"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "product_oregon" {
  provider             = aws.oregon
  name                 = "product-service"
  image_tag_mutability = "IMMUTABLE"
}
