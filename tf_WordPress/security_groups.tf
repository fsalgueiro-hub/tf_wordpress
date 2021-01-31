# Create SG for LB, only TCP/80, TCP/443 and outboud access
resource "aws_security_group" "lb-sg" {
  provider    = aws.region-wordpress
  name        = "lb-sg"
  description = "Allow 443 and traffic to Wordpress SG"
  vpc_id      = aws_vpc.vpc_wordpress.id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from anywhere for redirection"
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
}

# Create SG for allowing TCP/8080 from * and TCP/22 from IP in us-east-1
resource "aws_security_group" "wordpress-sg" {
  provider    = aws.region-wordpress
  name        = "wordpress-sg"
  description = "Allow TCP/8008 and TCP/22"
  vpc_id      = aws_vpc.vpc_wordpress.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description     = "Allow anyone on port 8080"
    from_port       = var.webserver-port
    to_port         = var.webserver-port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
