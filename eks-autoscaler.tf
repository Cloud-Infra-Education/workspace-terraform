# ==========================================
# 1. 서울 리전용 Cluster Autoscaler (ap-northeast-2)
# ==========================================

# 서울 IRSA (IAM Role)
module "cluster_autoscaler_irsa_seoul" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "sumin13-autoscaler-irsa-seoul"

  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [module.eks_seoul.cluster_name]

  oidc_providers = {
    eks = {
      provider_arn               = module.eks_seoul.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
}

# 서울 Helm Release
resource "helm_release" "cluster_autoscaler_seoul" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.37.0"

  set {
    name  = "autoDiscovery.clusterName"
    value = module.eks_seoul.cluster_name
  }
  set {
    name  = "awsRegion"
    value = "ap-northeast-2"
  }
  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cluster_autoscaler_irsa_seoul.iam_role_arn
  }

  # 클러스터 생성이 완료된 후 설치
  depends_on = [module.eks_seoul]
}

# ==========================================
# 2. 미국 오레곤 리전용 Cluster Autoscaler (us-west-2)
# ==========================================

# 미국 IRSA (IAM Role)
module "cluster_autoscaler_irsa_oregon" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "sumin13-autoscaler-irsa-oregon"

  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [module.eks_oregon.cluster_name]

  oidc_providers = {
    eks = {
      provider_arn               = module.eks_oregon.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
}

# 미국 Helm Release
resource "helm_release" "cluster_autoscaler_oregon" {
  provider   = helm.oregon
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.37.0"

  set {
    name  = "autoDiscovery.clusterName"
    value = module.eks_oregon.cluster_name
  }
  set {
    name  = "awsRegion"
    value = "us-west-2"
  }
  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cluster_autoscaler_irsa_oregon.iam_role_arn
  }

  # 클러스터 생성이 완료된 후 설치
  depends_on = [module.eks_oregon]
}
