terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
  alias  = "seoul"
}

provider "aws" {
  region = "us-west-2"
  alias  = "oregon"
}
