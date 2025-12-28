# 1)
terraform destroy -target=helm_release.argocd_seoul -auto-approve
terraform destroy -target=helm_release.argocd_oregon -auto-approve

# 2) K8s/Helm
terraform destroy -target=helm_release.aws_load_balancer_controller_kor -auto-approve
terraform destroy -target=kubernetes_service_account_v1.alb_controller_kor -auto-approve
terraform destroy -target=helm_release.aws_load_balancer_controller_oregon -auto-approve
terraform destroy -target=kubernetes_service_account_v1.alb_controller_oregon -auto-approve

# 3) IRSA
terraform destroy -target=module.alb_controller_irsa_kor -auto-approve
terraform destroy -target=module.alb_controller_irsa_oregon -auto-approve

# 4) EKS
terraform destroy -target=module.eks_seoul -auto-approve
terraform destroy -target=module.eks_oregon -auto-approve

# 5) Everything
terraform destroy -auto-approve


