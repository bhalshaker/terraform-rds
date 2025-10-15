 terraform {
   required_providers {
     aws = {
       source = "hashicorp/aws"
       version = "~> 4.16"
     }
   }

   required_version = ">= 1.2.0"
 }

 provider "aws" {
   region = "us-east-1"
 }


resource "aws_rds_cluster" "modern-engineering-aurora-postgressql-cluster" {
  cluster_identifier      = "modern-engineering-aurora-postgresql-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "11.9"
  availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]
  master_username         = "myusername"
  master_password         = "The.5ecret?P4ssw0rd"
  database_name           = "mydatabase"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  apply_immediately       = true
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "modern-engineering-aurora-postgressql-instances" {
  count              = 1
  identifier         = "modern-engineering-aurora-postgresql-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.modern-engineering-aurora-postgressql-cluster.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.modern-engineering-aurora-postgressql-cluster.engine
  engine_version     = aws_rds_cluster.modern-engineering-aurora-postgressql-cluster.engine_version
}

output "db_host" {
  value       = aws_rds_cluster.modern-engineering-aurora-postgressql-cluster.endpoint
  description = "The endpoint of the RDS cluster"
}
