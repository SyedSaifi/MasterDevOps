resource "aws_instance" "mysecondinstance" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> inventory"
  }
}
