# Public Security Group: Chỉ cho phép SSH từ IP của bạn [cite: 26]
resource "aws_security_group" "public_sg" {
  name        = "NT548-Public-SG"
  description = "Allow SSH from specific IP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Private Security Group: Chỉ cho phép SSH từ Public Instance 
resource "aws_security_group" "private_sg" {
  name        = "NT548-Private-SG"
  description = "Allow SSH from Public SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id] # Chỉ nhận từ Public SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
