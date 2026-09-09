module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "my-eks-cluster"
  kubernetes_version = "1.35"

  endpoint_public_access  = true
  endpoint_private_access = true

  vpc_id     = module.my-vpc.vpc_id
  subnet_ids = module.my-vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["c7i-flex.large"]

      ami_type = "AL2023_x86_64_STANDARD"
    }
  }

  tags = {
    Environment = "development"
    Application = "nginx-app"
  }
}


resource "aws_eks_addon" "vpc_cni" {
  cluster_name = module.eks.cluster_name
  addon_name   = "vpc-cni"
  most_recent  = true
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = module.eks.cluster_name
  addon_name   = "kube-proxy"
  most_recent  = true
}

resource "aws_eks_addon" "coredns" {
  cluster_name = module.eks.cluster_name
  addon_name   = "coredns"
  most_recent  = true
}