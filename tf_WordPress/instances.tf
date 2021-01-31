# Get Ubuntu 18.04 AMI ID using SSM parameter endpoint in us-east-1
data "aws_ssm_parameter" "ubuntuAmi" {
  provider = aws.region-wordpress
  name     = "/aws/service/canonical/ubuntu/server/18.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "wordpress-key" {
  provider   = aws.region-wordpress
  key_name   = "wordpress"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create and bootstrap EC in us-east-1
resource "aws_instance" "wordpress-east" {
  provider                    = aws.region-wordpress
  ami                         = data.aws_ssm_parameter.ubuntuAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.wordpress-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.wordpress-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id
  tags = {
    Name = "wordpress_tf"
  }
  depends_on = [aws_main_route_table_association.set-wordpress-default-rt-assoc]
  provisioner "local-exec" {

    command = <<EOF

aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-wordpress} --instance-ids ${self.id}

ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/install_wordpress.yml

EOF

  }
}

