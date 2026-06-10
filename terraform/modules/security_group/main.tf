resource "aws_security_group" "sg_project"{
    name = var.security_groups_name

    dynamic "ingress" {
        for_each = var.security_groups_ports
        content{
            protocol = var.protocol
            from_port = ingress.value
            cidr_blocks = var.cidr_blocks
        }
    }
    egress
}