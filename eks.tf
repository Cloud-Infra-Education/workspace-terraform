# ==========================================
# 1. 서울 리전 EKS 클러스터 (eks_seoul)
# ==========================================
module "eks_seoul" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  providers = {
    aws = aws.seoul
  }

  cluster_name    = "sumin13-formation-lap-seoul"
  cluster_version = "1.34"

  vpc_id = module.kor_vpc.vpc_id

  # [에러 수정] VPC 모듈의 출력 필터가 오작동하므로 전체 리스트 중 앞의 2개만 사용
  subnet_ids = slice(module.kor_vpc.private_subnet_ids, 0, 2)

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.eks_public_access_cidrs

  eks_managed_node_groups = {
    sumin13-workers = {
      instance_types = ["t3.small"]
      desired_size   = 2
      min_size       = 2
      max_size       = 5 # Autoscaler 테스트를 위한 최대 확장 가능 수

      # Cluster Autoscaler가 이 노드 그룹을 인식하기 위한 필수 태그
      tags = {
        "k8s.io/cluster-autoscaler/enabled"                    = "true"
        "k8s.io/cluster-autoscaler/sumin13-formation-lap-seoul" = "owned"
      }
    }
  }
}

# ==========================================
# 2. 미국 오레곤 리전 EKS 클러스터 (eks_oregon)
# ==========================================
module "eks_oregon" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  providers = {
    aws = aws.oregon
  }

  cluster_name    = "sumin13-formation-lap-oregon"
  cluster_version = "1.34"

  vpc_id = module.usa_vpc.vpc_id

  # [에러 수정] 미국 리전도 동일하게 앞의 2개 서브넷을 선택
  subnet_ids = slice(module.usa_vpc.private_subnet_ids, 0, 2)

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.eks_public_access_cidrs

  eks_managed_node_groups = {
    sumin13-workers = {
      instance_types = ["t3.small"]
      desired_size   = 2
      min_size       = 2
      max_size       = 5 

      # Cluster Autoscaler가 이 노드 그룹을 인식하기 위한 필수 태그
      tags = {
        "k8s.io/cluster-autoscaler/enabled"                     = "true"
        "k8s.io/cluster-autoscaler/sumin13-formation-lap-oregon" = "owned"
      }
    }
  }
}
