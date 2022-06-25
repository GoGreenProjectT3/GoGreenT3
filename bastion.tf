resource "aws_instance" "bastion" {
  ami                         = "ami-0d9858aa3c6322f73"
  subnet_id                   = aws_subnet.public_subnet1a.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  tags = {
    "Name" = "Bastion-EC2"
  }
}
resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
}


resource "aws_security_group" "bastion" {
  name        = "Bastion host"
  description = "Allow SSH access to bastion host and outbound internet access"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
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

# Copies the ssh key file to home dir
# provisioner "file" {
#   source      = "TEST.pem"
#   destination = "/home/ec2-user/TEST.pem"
#   connection {
#     type        = "ssh"
#     user        = "ec2-user"
#     private_key = file("TEST.pem")
#     host        = self.public_ip
#   }
# }
# //chmod key 400 on EC2 instance
# provisioner "remote-exec" {
#   inline = ["chmod 400 ~/TEST.pem"]
#   connection {
#     type        = "ssh"
#     user        = "ec2-user"
#     private_key = file("TEST.pem")
#     host        = self.public_ip
#   }
# }

