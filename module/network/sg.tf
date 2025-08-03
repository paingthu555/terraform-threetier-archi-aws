# Create bastion host sg

resource "aws_security_group" "terra-bastion-sg" {
  name        = "terra-bastion-sg"
  description = "Allowed ssh traffic from public"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create Web sg
resource "aws_security_group" "terra-frontend-web-sg" {
  name        = "terra-frontend-web-sg"
  description = "Allowed ssh traffic from bastion host and http traffic from LB"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.terra-bastion-sg.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.terra-lb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create App sg
resource "aws_security_group" "terra-backend-app-sg" {
  name        = "terra-backend-app-sg"
  vpc_id      = aws_vpc.terraform-vpc.id
  description = "Allowed http traffic from frontend and ssh traffic from bastion host"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.terra-frontend-web-sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.terra-bastion-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Creaet DB sg
resource "aws_security_group" "terra-db-sg" {
  name        = "terra-db-sg"
  description = "Allowed mysql db port from backend app"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.terra-backend-app-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Load Balancer SG
resource "aws_security_group" "terra-lb-sg" {
  name        = "terra-lb-sg"
  description = "Allow Inbound Traffic from terra-sg"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "terra-lb-sg"
  }
}

