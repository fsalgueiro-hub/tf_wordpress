# Create ouptus to display at the end of apply
output "WordPress-Public-IP" {
  value = aws_instance.wordpress-east.public_ip
}

output "LB-DNS-NAME" {
  value = aws_lb.application-lb.dns_name
}