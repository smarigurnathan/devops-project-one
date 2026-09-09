module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # EKS cluster
  name               = "my-eks-cluster"
  kubernetes_version = "1.35"

  # EKS endpoint
  endpoint_public_access  = true
  endpoint_private_access = true

  # VPC configuration
  vpc_id     = module.my-vpc.vpc_id
  subnet_ids = module.my-vpc.private_subnets

  # Give Terraform creator admin access
  enable_cluster_creator_admin_permissions = true

  # EKS managed add-ons
  cluster_addons = {
    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      most_recent = true
    }
  }

  # Managed worker nodes
  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["c7i-flex.large"]

      ami_type = "AL2023_x86_64_STANDARD"
    }
  }

  # Tags
  tags = {
    Environment = "development"
    Application = "nginx-app"
  }
}