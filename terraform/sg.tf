locals {
  app_ports = [5000, 5001, 5858, 80]
  db_ports  = [6379, 5432]
}

resource "aws_security_group" "main_sg" {
  name        = local.project_name
  description = var.security_group_description
  vpc_id      = data.aws_vpc.default_vpc.id

  dynamic "ingress" {
    for_each = local.app_ports
    content {
      description      = var.security_group_description
      from_port        = ingress.value
      to_port          = element(local.app_ports, index(local.app_ports, ingress.value))
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.default_tags
}

resource "aws_security_group" "databases_sg" {
  name        = "${local.project_name}-db"
  description = var.db_security_group_description
  vpc_id      = data.aws_vpc.default_vpc.id

  dynamic "ingress" {
    for_each = local.db_ports
    content {
      description     = var.db_security_group_description
      from_port       = ingress.value
      to_port         = element(local.db_ports, index(local.db_ports, ingress.value))
      protocol        = "tcp"
      security_groups = [aws_security_group.main_sg.id]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.default_tags
}

