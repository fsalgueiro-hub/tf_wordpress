# Configure an LB for wordpress
resource "aws_lb" "application-lb" {
  provider           = aws.region-wordpress
  name               = "wordpress-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  tags = {
    Name = "Wordpress-LB"
  }
}

# Configure the LB target group
resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws.region-wordpress
  name        = "app-lb-tg"
  port        = var.webserver-port
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_wordpress.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.webserver-port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "wordpress-target-group"
  }
}

# Configure the LB Listener
resource "aws_lb_listener" "wordpress-listener-http" {
  provider          = aws.region-wordpress
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.id
  }
}

# Configure the LB Group attachment
resource "aws_lb_target_group_attachment" "wordpress-attach" {
  provider         = aws.region-wordpress
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = aws_instance.wordpress-east.id
  port             = var.webserver-port
}