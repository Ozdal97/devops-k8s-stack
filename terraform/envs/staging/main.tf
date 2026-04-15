terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "ozdal-tfstate"
    key            = "devops-k8s-stack/staging/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "tfstate-lock"
    encrypt        = true
  }

  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.40" }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "staging"
      ManagedBy   = "terraform"
      Project     = "devops-k8s-stack"
    }
  }
}

module "vpc" {
  source       = "../../modules/vpc"
  name         = "k8s-staging"
  cluster_name = var.cluster_name
}

module "eks" {
  source             = "../../modules/eks"
  cluster_name       = var.cluster_name
  kubernetes_version = "1.29"
  subnet_ids         = module.vpc.private_subnet_ids
  desired_size       = 2
  min_size           = 2
  max_size           = 4
  instance_types     = ["t3.medium"]
}

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}
