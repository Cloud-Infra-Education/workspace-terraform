locals {
  # Argo Helm repo + chart info
  argocd_helm_repo     = "https://argoproj.github.io/argo-helm"
  argocd_helm_chart    = "argo-cd"
  argocd_release_name  = "argocd"
}

# -------------------------
# 1. 서울 리전 (Seoul): ArgoCD 설치
# -------------------------
resource "helm_release" "argocd_seoul" {
  name       = local.argocd_release_name
  repository = local.argocd_helm_repo
  chart      = local.argocd_helm_chart
  namespace  = var.argocd_namespace

  create_namespace = true
  version          = var.argocd_chart_version != "" ? var.argocd_chart_version : null

  wait    = true
  timeout = 600

  set {
    name  = "crds.install"
    value = "true"
  }

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  # [중요] 서울 EKS 클러스터 생성이 완료될 때까지 대기
  depends_on = [module.eks_seoul] 
}

# -------------------------
# 2. 미국 오레곤 리전 (Oregon): ArgoCD 설치
# -------------------------
resource "helm_release" "argocd_oregon" {
  provider   = helm.oregon # providers.tf에 정의된 미국용 헬름 프로바이더 사용
  name       = local.argocd_release_name
  repository = local.argocd_helm_repo
  chart      = local.argocd_helm_chart
  namespace  = var.argocd_namespace

  create_namespace = true
  version          = var.argocd_chart_version != "" ? var.argocd_chart_version : null

  wait    = true
  timeout = 600

  set {
    name  = "crds.install"
    value = "true"
  }

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  # [중요] 미국 EKS 클러스터 생성이 완료될 때까지 대기
  depends_on = [module.eks_oregon]
}
