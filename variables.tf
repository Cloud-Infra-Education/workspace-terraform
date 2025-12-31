variable "key_name_kor" {
  description = "EC2 Key Pair in Seoul Region"
  type        = string
}

variable "key_name_usa" {
  description = "EC2 Key Pair in Oregon Region"
  type        = string
}

variable "admin_cidr" {
  type = string
}

variable "bastion_instance_type" {
  default = "t3.micro"
}

#온프레미스 환경 정보 추가
variable "onprem_public_ip" {
  type        = string
}

variable "onprem_private_cidr" {
  default     = "192.168.1.0/24"
}

variable "account_id" {}
variable "eks_public_access_cidrs" { type = list(string) }

