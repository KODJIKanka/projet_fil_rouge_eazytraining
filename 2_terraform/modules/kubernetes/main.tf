resource "aws_instance" "ec2_project" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = ["${var.security_groups_name}"]
  associate_public_ip_address = true
  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.username
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
    script = "./scripts/kubernetes.sh"
  }
  provisioner "local-exec" {
    command = "echo Your public IP is: ${self.public_ip} >> ./ip/kubernetes_ip.txt"

  }
  tags = {
    Name = var.instance_name
  }
}