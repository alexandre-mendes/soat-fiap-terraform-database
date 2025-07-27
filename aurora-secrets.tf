provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_cluster.name, "--region", data.aws_region.current.name]
  }
}

data "aws_eks_cluster" "eks_cluster" {
  name = "soat-cluster"
}

data "aws_region" "current" {}

resource "kubernetes_secret" "aurora_credentials" {
  metadata {
    name      = "aurora-db-credentials"
    namespace = "default"
  }

  data = {
    DB_HOST     = aws_rds_cluster.aurora_cluster.endpoint
    DB_USERNAME = aws_rds_cluster.aurora_cluster.master_username
    DB_PASSWORD = random_password.master_password.result
  }
}