resource "aws_security_group" "aurora_sg" {
  name        = "soat-aurora-sg"
  description = "Permite acesso ao Aurora PostgreSQL"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.aws_security_group.eks_sg.id]
    description     = "Permite trafego do EKS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "default" {
  name        = "aurora-subnet-group"
  subnet_ids = data.aws_subnets.subnets.ids
}


resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "soat-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "13.9"
  database_name           = "soatdb"
  master_username         = "auroraadmin"
  master_password         = var.db_master_password
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier          = "soat-aurora-instance"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = "db.t3.medium"
  engine              = "aurora-postgresql"
}