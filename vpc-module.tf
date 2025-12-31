module "kor_vpc" {
  source    = "./modules/vpc"
  providers = { aws = aws.seoul }

  # 1. 리소스 이름에 본인 이름(sumin13) 반영
  name = "sumin13-KOR-Primary-VPC"
  
  # 2. 서울 CIDR을 10.13.0.0/16으로 변경
  cidr = "10.13.0.0/16"
  azs  = ["ap-northeast-2a", "ap-northeast-2b"]

  # 3. 모든 서브넷 대역을 10.13.x.x로 변경
  public_subnets      = ["10.13.1.0/24", "10.13.2.0/24"]
  public_subnet_names = ["sumin13-KOR-Public-A", "sumin13-KOR-Public-B"]

  private_subnets = [
    "10.13.11.0/24",
    "10.13.12.0/24",
    "10.13.21.0/24",
    "10.13.22.0/24"
  ]
  private_subnet_names = [
    "sumin13-KOR-Priv-EKS-A",
    "sumin13-KOR-Priv-EKS-B",
    "sumin13-KOR-Priv-DB-A",
    "sumin13-KOR-Priv-DB-B"
  ]

  tgw_subnets      = ["10.13.31.0/28", "10.13.32.0/28"]
  tgw_subnet_names = ["sumin13-KOR-TGW-A", "sumin13-KOR-TGW-B"]

  key_name      = var.key_name_kor
  admin_cidr    = var.admin_cidr
  tgw_id        = aws_ec2_transit_gateway.kor.id
  
  # 4. 상대방(미국) VPC의 바뀐 대역을 정확히 지정
  peer_vpc_cidr = "10.113.0.0/16" 
}

module "usa_vpc" {
  source    = "./modules/vpc"
  providers = { aws = aws.oregon }

  # 1. 리소스 이름에 본인 이름(sumin13) 반영
  name = "sumin13-USA-Primary-VPC"
  
  # 2. 미국 CIDR은 중복 방지를 위해 10.113.0.0/16으로 변경
  cidr = "10.113.0.0/16"
  azs  = ["us-west-2a", "us-west-2b"]

  # 3. 모든 서브넷 대역을 10.113.x.x로 변경
  public_subnets      = ["10.113.1.0/24", "10.113.2.0/24"]
  public_subnet_names = ["sumin13-USA-Public-A", "sumin13-USA-Public-B"]

  private_subnets = [
    "10.113.11.0/24",
    "10.113.12.0/24",
    "10.113.21.0/24",
    "10.113.22.0/24"
  ]
  private_subnet_names = [
    "sumin13-USA-Priv-EKS-A",
    "sumin13-USA-Priv-EKS-B",
    "sumin13-USA-Priv-DB-A",
    "sumin13-USA-Priv-DB-B"
  ]

  tgw_subnets      = ["10.113.31.0/28", "10.113.32.0/28"]
  tgw_subnet_names = ["sumin13-USA-TGW-A", "sumin13-USA-TGW-B"]

  key_name      = var.key_name_usa
  admin_cidr    = var.admin_cidr
  tgw_id        = aws_ec2_transit_gateway.usa.id
  
  # 4. 상대방(서울) VPC의 바뀐 대역을 정확히 지정
  peer_vpc_cidr = "10.13.0.0/16"
}
