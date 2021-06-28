
resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name                          = "stocks-vpc"
  cidr                          = "10.0.0.0/16"
  azs                           = data.aws_availability_zones.available.names
  private_subnets               = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets                = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  database_subnets              = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  enable_nat_gateway            = true
  single_nat_gateway            = true
  enable_dns_hostnames          = true
  create_database_subnet_group  = true
  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

output "vpc_id" {
  description = "VPC subnets."
  value       = module.vpc.private_subnets
}

output "vpc_database_subnet" {
  description = "VPC database subnet group."
  value       = module.vpc.database_subnet_group
}

output "eks_node_sg" {
  description = "sg of worker nodes on cluster"
  value       = module.kubernetes-cluster-provision.aws_eks_worker_security_group_id
}