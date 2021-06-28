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

//data "terraform_remote_state" "eks" {
//  backend = "local"
//
//  config = {
//    path = "../learn-terraform-provision-eks-cluster/terraform.tfstate"
//  }
//}
//
//data "terraform_remote_state" "rds" {
//  backend = "local"
//
//  config = {
//    path = "../stock-reader-db/terraform.tfstate"
//  }
//}

//# Retrieve EKS cluster information
//provider "aws" {
//  region = data.terraform_remote_state.eks.outputs.region
//}
//
//data "aws_eks_cluster" "cluster" {
//  name = data.terraform_remote_state.eks.outputs.cluster_id
//}

//data "aws_db_instance" "database" {
//  db_instance_identifier = data.terraform_remote_state.rds.aws_db_instance.stock-reader-db2.identifier
//}

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

