
provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "education-eks-${random_string.suffix.result}"
}


module "kubernetes-cluster-provision" {
  source        = "./stock-eks-cluster-provision"
  cluster_name  = local.cluster_name
  vpc           = module.vpc
  aws_security_group_1 = aws_security_group.worker_group_mgmt_one
  aws_security_group_2 = aws_security_group.worker_group_mgmt_two
}

module "kubernetes-cluster-resources" {
  source                                = "./stock-eks-cluster-resources"
  stock-reader-db-hostname              = module.stock-reader-db.stock-reader-db-hostname
  stock-trading-algorithms-db-hostname  = module.stock-reader-db.stock-trading-algorithms-db-hostname
  eks_cluster                           = module.kubernetes-cluster-provision
}

module "stock-reader-db" {
  source = "./stock-reader-db"
  aws_security_group = aws_security_group.worker_group_mgmt_one
  database_subnet_group = module.vpc.database_subnet_group

}