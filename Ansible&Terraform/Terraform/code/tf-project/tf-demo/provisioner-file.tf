resource "aws_instance" "mythirdinstance" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  provisioner "file" {
    destination = "/some/file/in/remote/machine"
    # content = "Lorem Ipsum"
    source = "/some/file/from/local/system"
    connection {
      host = self.public_ip
      user = "ubuntu"
      type = "ssh"
      private_key = file("/path/to/private/key")
    }
  }
}
