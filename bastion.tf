resource "aws_instance" "bastion" {
  ami                         = "ami-0d9858aa3c6322f73"
  subnet_id                   = aws_subnet.public_us_west_1a.id
  instance_type               = "t2-micro"
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  tags = {
    "Name" = "Public-EC2"
  }
}
resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
}
// Generate the SSH keypair that we’ll use to configure the EC2 instance.
// After that, write the private key to a local file and upload the public key to AWS
resource "tls_private_key" "key" {
  algorithm = "RSA"
}
# resource "local_file" "private_key" {
#   filename          = "TEST.pem"
#   sensitive_content = local_sensitive_file.private_key #tls_private_key.key.private_key_pem
#   file_permission   = "0400"
# }
resource "aws_key_pair" "key_pair" {
  key_name   = "TEST"
  public_key = tls_private_key.key.public_key_openssh
}
resource "aws_security_group" "bastion" {
  name        = "Bastion host"
  description = "Allow SSH access to bastion host and outbound internet access"
  vpc_id      = aws_vpc.main_vpc.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh" {
  protocol          = "TCP"
  from_port         = 22
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "internet" {
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "intranet" {
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}
# Create Security Group for the Bastion Host aka Jump Box
# terraform aws create security group
resource "aws_security_group" "ssh-security-group" {
  name        = "SSH Security Group"
  description = "Enable SSH access on Port 22"
  vpc_id      = aws_vpc.main_vpc.id
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh-location}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SSH Security Group"
  }
}
# Create Security Group for the Web Server
# terraform aws create security group
resource "aws_security_group" "webserver-security-group" {
  name        = "Web Server Security Group"
  description = "Enable HTTP/HTTPS access on Port 80/443 via ALB and SSH access on Port 22 via SSH SG"
  vpc_id      = aws_vpc.main_vpc.id
  ingress {
    description     = "SSH Access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ssh-security-group.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Web Server Security Group"
  }
}
/*#Create a new EC2 launch configuration
resource "aws_instance" "ec2_public" {
ami                    = "ami-0eb7496c2e0403237"
instance_type               = "${var.instance_type}"
key_name                    = "${var.key_name}"
security_groups             = ["${aws_security_group.ssh-security-group.id}"]
subnet_id                   = "aws_subnet.public_us_west_1a.id"
associate_public_ip_address = true
#user_data                   = "${data.template_file.provision.rendered}"
#iam_instance_profile = "${aws_iam_instance_profile.some_profile.id}"
lifecycle {
create_before_destroy = true
}
tags = {
"Name" = "EC2-PUBLIC"
}*/
# Copies the ssh key file to home dir
# Copies the ssh key file to home dir
# provisioner "file" {
#   source      = "./${var.key_name}.pem"
#   destination = "/home/ec2-user/${var.key_name}.pem"
#   connection {
#     type        = "ssh"
#     user        = "ec2-user"
#     private_key = file("${var.key_name}.pem")
#     host        = self.public_ip
#   }
# }
# //chmod key 400 on EC2 instance
# provisioner "remote-exec" {
#   inline = ["chmod 400 ~/${var.key_name}.pem"]
#   connection {
#     type        = "ssh"
#     user        = "ec2-user"
#     private_key = file("${var.key_name}.pem")
#     host        = self.public_ip
#   }
# }

/*#Create a new EC2 launch configuration
resource "aws_instance" "ec2_private" {
#name_prefix                 = "terraform-example-web-instance"
ami                    = "ami-0eb7496c2e0403237"
instance_type               = "${var.instance_type}"
key_name                    = "${var.key_name}"
security_groups             = ["${aws_security_group.webserver-security-group.id}"]
subnet_id                   = "${aws_subnet.private-subnet-1.id}"
associate_public_ip_address = false
#user_data                   = "${data.template_file.provision.rendered}"
#iam_instance_profile = "${aws_iam_instance_profile.some_profile.id}"
lifecycle {
create_before_destroy = true
}
tags = {
"Name" = "EC2-Private"
}
}*/