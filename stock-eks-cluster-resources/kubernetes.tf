variable "eks_cluster" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

provider "kubernetes" {
  host                   = var.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(var.eks_cluster.cluster_cert_auth)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      var.eks_cluster.cluster_name
    ]
  }
}

