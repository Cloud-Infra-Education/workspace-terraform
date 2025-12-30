# 1. 관리형 노드 그룹 (eksctl 1번 대응: 2~5대 설정)
resource "aws_eks_node_group" "standard_nodes" {
  cluster_name    = var.cluster_name
  node_group_name = "standard-nodes"
  node_role_arn   = "arn:aws:iam::${var.account_id}:role/eks-node-role" # 기존 역할 참조
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 5
  }

  instance_types = ["t3.medium"]
}

# 2. Cluster Autoscaler용 IRSA (eksctl 2번 대응)
resource "aws_iam_role" "cluster_autoscaler_role" {
  name = "cluster-autoscaler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${var.account_id}:oidc-provider/${var.oidc_url}"
      }
      Condition = {
        StringEquals = {
          "${var.oidc_url}:sub": "system:serviceaccount:kube-system:cluster-autoscaler"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "autoscaler_policy_attach" {
  role       = aws_iam_role.cluster_autoscaler_role.name
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
}

# 3. Helm 배포 (eksctl 3번 대응 및 최적화 옵션 포함)
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler_role.arn
  }

  # 최적화 옵션 (patch 명령어 내용 반영)
  set {
    name  = "extraArgs.balance-similar-node-groups"
    value = "true"
  }
  set {
    name  = "extraArgs.skip-nodes-with-system-pods"
    value = "false"
  }
}
