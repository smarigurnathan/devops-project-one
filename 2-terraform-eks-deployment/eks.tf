module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # EKS cluster
  name               = "my-eks-cluster"
  kubernetes_version = "1.35"

  # Allow kubectl access through the public EKS endpoint
  endpoint_public_access = true

  # VPC configuration
  vpc_id     = module.my-vpc.vpc_id
  subnet_ids = module.my-vpc.private_subnets

  # Give the identity running Terraform admin access to the cluster
  enable_cluster_creator_admin_permissions = true

  # Managed worker nodes
  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.small"]

      # Required/suitable for Kubernetes 1.35
      ami_type = "AL2023_x86_64_STANDARD"
    }
  }

  # Tags
  tags = {
    Environment = "development"
    Application = "nginx-app"
  }
}