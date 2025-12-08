provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  cluster_name = var.cluster_name
}

# -------------------- VPC --------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "particle41-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

# -------------------- EKS --------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2023_x86_64_STANDARD"
  }

  eks_managed_node_groups = {
    one = {
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 1
      desired_size   = 1
    }

    two = {
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 1
      desired_size   = 1
    }
  }
}

# -------------------- EBS CSI ROLE --------------------
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.39.0"

  role_name = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  role_policy_arns = {
    ebs = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }
}


# -------------------- Kubernetes Provider Auth --------------------
data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# -------------------- Deployment --------------------
resource "kubernetes_deployment" "time-service" {
  metadata {
    name      = "time-service"
    namespace = "default"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "time-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "time-service"
        }
      }

      spec {
        container {
          name  = "simple-time-service"
          image = var.docker_image

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# -------------------- Service --------------------
resource "kubernetes_service" "time-service" {
  metadata {
    name      = "time-service"
    namespace = "default"

    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"   # Ensures real IP
    }
  }

  spec {
    selector = {
      app = "time-service"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"

    # Critical for REAL client IP
    external_traffic_policy = "Local"
  }
}
