locals {
  pvt-key-file = "id_rsa_from_tf"
  pub-key-file = "id_rsa_from_tf.pub"
}
resource "aws_security_group" "my-sg-1" {
  name = "securitygroup-from-tf"
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "security group-from-tf"
  }
}
resource "tls_private_key" "rsa-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "pvt-key" {
  content  = tls_private_key.rsa-key.private_key_pem
  filename = local.pvt-key-file
}
resource "local_file" "pub-key" {
  content  = tls_private_key.rsa-key.public_key_openssh
  filename = local.pub-key-file
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(local_file.pub-key.filename)
}
resource "aws_instance" "mythirdinstance" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.my-sg-1.name]
  key_name        = aws_key_pair.deployer.key_name
  provisioner "remote-exec" {
    inline = ["sudo apt update"]
    connection {
      host = self.public_ip
      user = "ubuntu"
      type = "ssh"
      private_key = file(local_file.pvt-key.filename)
    }
  }
}
