module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                   = local.name
  endpoint_public_access = true

  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent   = true
      before_compute = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    cluster-wg = {
      ami_type                               = "AL2023_x86_64_STANDARD"
      instance_types                         = ["t3.large"]
      attach_cluster_primary_security_group  = true

      min_size      = 1
      max_size      = 2
      desired_size  = 1
      capacity_type = "SPOT"
      tags = {
        ExtraTag = "helloworld"
      }
    }
  }

  tags = local.tags
}
