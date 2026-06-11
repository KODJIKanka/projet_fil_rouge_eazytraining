data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

locals {
  ami_id = data.aws_ami.ubuntu.id
  filename = "./keypair/${var.key_name}.pem"
  instance_name = var.stack
}

module "keypair" {
  source = "./modules/keypair"
  key_name = var.key_name
  filename = local.filename  
}

module "security_group" {
  source = "./modules/security_group"
  security_groups_name = var.security_groups_name
  security_groups_ports = var.security_groups_ports
  protocol = var.protocol
}

module "ec2_instance" {
  source = "./modules/docker"
  instance_name = local.instance_name
  instance_type = var.instance_type
  ami = local.ami_id
  key_name = var.key_name
  security_groups_name = module.security_group.sg_name
  private_key_path = local.filename
  username = var.username
}