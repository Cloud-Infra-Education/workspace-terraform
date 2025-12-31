terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws        = { source = "hashicorp/aws", version = "~> 5.0" }
    time       = { source = "hashicorp/time" }
    helm       = { source = "hashicorp/helm", version = "~> 2.12" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.0" }
  }
}

# ==========================================
# 1. AWS 프로바이더 설정 (중복 금지!)
# ==========================================

# 기본 프로바이더
provider "aws" {
  region = "ap-northeast-2"
}

# 서울 리전 별칭
provider "aws" {
  region = "ap-northeast-2"
  alias  = "seoul"
}

# 오레곤 리전 별칭
provider "aws" {
  region = "us-west-2"
  alias  = "oregon"
}

# ==========================================
# 2. 서울 리전 (Seoul) 동적 설정
# ==========================================

# [중요] 데이터 소스에 depends_on을 걸어 클러스터 생성 후 읽도록 강제
data "aws_eks_cluster" "seoul" {
  provider   = aws.seoul
  name       = module.eks_seoul.cluster_name
  depends_on = [module.eks_seoul] 
}

data "aws_eks_cluster_auth" "seoul" {
  provider   = aws.seoul
  name       = module.eks_seoul.cluster_name
  depends_on = [module.eks_seoul]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.seoul.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.seoul.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.seoul.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.seoul.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.seoul.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.seoul.token
  }
}

# ==========================================
# 3. 미국 오레곤 리전 (Oregon) 동적 설정
# ==========================================

data "aws_eks_cluster" "oregon" {
  provider   = aws.oregon
  name       = module.eks_oregon.cluster_name
  depends_on = [module.eks_oregon]
}

data "aws_eks_cluster_auth" "oregon" {
  provider   = aws.oregon
  name       = module.eks_oregon.cluster_name
  depends_on = [module.eks_oregon]
}

provider "kubernetes" {
  alias                  = "oregon"
  host                   = data.aws_eks_cluster.oregon.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.oregon.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.oregon.token
}

provider "helm" {
  alias = "oregon"
  kubernetes {
    host                   = data.aws_eks_cluster.oregon.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.oregon.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.oregon.token
  }
}
