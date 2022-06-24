<<<<<<< HEAD
#Creating S3bucket
resource "aws_s3_bucket" "a" {
  bucket = "my-ggn-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.a.id
  acl    = "private"
}
#Static Website Hosting
# resource "aws_s3_bucket" "b" {
#   bucket = "s3-website-test.hashicorp.com"
#   acl    = "public-read"
 
#   website {
#     index_document = "index.html"
#     error_document = "error.html"

#     routing_rules = <<EOF
# [{
#     "Condition": {
#         "KeyPrefixEquals": "docs/"
#     },
#     "Redirect": {
#         "ReplaceKeyPrefixWith": "documents/"
#     }
# }]
# EOF
#   }
# }

# Creating CORS
resource "aws_s3_bucket" "d" {
  bucket = "my-ggn-bucket"
}

resource "aws_s3_bucket_cors_configuration" "b" {
  bucket = aws_s3_bucket.a.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://s3-website-test.hashicorp.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

#Creating a Lifecycle Configuration for a bucket with versioning

resource "aws_s3_bucket" "bucket" {
  bucket = "my-ggn-bucket"
  acl    = "private"
}

resource "aws_s3_bucket" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "b" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    id = "log"

    expiration {
      days = 90
    }

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          =60
      storage_class = "GLACIER"
    }
  }

  rule {
    id = "tmp"

    filter {
      prefix = "tmp/"
    }

    expiration {
      date = "2027-01-13T00:00:00Z"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket" "versioning_bucket" {
  bucket = "my-ggn-bucket"
}

resource "aws_s3_bucket_acl" "versioning_bucket_acl" {
  bucket = aws_s3_bucket.versioning_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.versioning_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-b" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  bucket = aws_s3_bucket.versioning_bucket.bucket

  rule {
    id = "config"

    filter {
      prefix = "config/"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}
=======
# Create SysAdmin Group and Users
resource "aws_iam_group" "SysAdmin" {
  name = "SysAdmin"
}

resource "aws_iam_user" "Sysadmin1" {
  name = "Sysadmin1"
}

resource "aws_iam_user" "Sysadmin2" {
  name = "Sysadmin2"
}

# Asign Sysadmin users to SysAdmin Group
resource "aws_iam_group_membership" "assignment1" {
  name = "sysadmin-membership"

  users = [
    aws_iam_user.Sysadmin1.name,
    aws_iam_user.Sysadmin2.name
  ]

  group = aws_iam_group.SysAdmin.name
}

# Attaching policy to SysAdmin Group
resource "aws_iam_group_policy_attachment" "admin" {
  group      = aws_iam_group.SysAdmin.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
}

# Create DBAdmin Group and users
resource "aws_iam_group" "DBAdmin" {
  name = "DBAdmin"
}

resource "aws_iam_user" "dbadmin1" {
  name = "dbadmin1"
}

resource "aws_iam_user" "dbadmin2" {
  name = "dbadmin2"
}

# Asign dbadmin users to DBAdmin Group
resource "aws_iam_group_membership" "assignment2" {
  name = "dbadmin-membership"

  users = [
    aws_iam_user.dbadmin1.name,
    aws_iam_user.dbadmin2.name
  ]

  group = aws_iam_group.DBAdmin.name
}

# Attaching policy to DBAdmin Group
resource "aws_iam_group_policy_attachment" "database" {
  group      = aws_iam_group.DBAdmin.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
}

# Create Monitor Group and Minitorusers
resource "aws_iam_group" "Monitor" {
  name = "Monitor"
}

resource "aws_iam_user" "monitoruser1" {
  name = "monitoruser1"
}

resource "aws_iam_user" "monitoruser2" {
  name = "monitoruser2"
}

resource "aws_iam_user" "monitoruser3" {
  name = "monitoruser3"
}

resource "aws_iam_user" "monitoruser4" {
  name = "monitoruser4"
}

# Asign monitorusers to Monitor Group
resource "aws_iam_group_membership" "assignment3" {
  name = "monitor-membership"

  users = [
    aws_iam_user.monitoruser1.name,
    aws_iam_user.monitoruser2.name,
    aws_iam_user.monitoruser3.name,
    aws_iam_user.monitoruser4.name
  ]

  group = aws_iam_group.Monitor.name
}

# Attaching policies to Monitor Group
resource "aws_iam_group_policy_attachment" "ec2" {
  group      = aws_iam_group.Monitor.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "s3" {
  group      = aws_iam_group.Monitor.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "RDS" {
  group      = aws_iam_group.Monitor.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

# Create Password Policy for users
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  max_password_age               = 90
  password_reuse_prevention      = 3
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  
}

# Create and attach roles
>>>>>>> 6d8e3203758daaba39d73c9af4dc83146a66c6fc
