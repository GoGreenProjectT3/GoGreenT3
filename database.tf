<<<<<<< HEAD
# provider "aws" {
#   region = "us-west-1"
# }

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.0"
#     }
#   }
# }
=======


/*terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}*/
>>>>>>> 8dd1ab5862f8bf5be677a0a5f09c4cd221890aaf

resource "aws_db_instance" "project-1" {
  allocated_storage    = 20
  identifier           = "mysql-db-01"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "db_name"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_db_instance" "project-2" {
  allocated_storage    = 20
  identifier           = "mysql-db-02"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "db_name"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

