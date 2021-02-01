# Deployment of WordPress Environment
Terraform scripts and ansible playbooks to create and evnironment and install WordPress on an AWS ec2-system

## Clone this repo
git clone <repo>

## install Docker and docker-compose in your system
sudo apt-get install docker
sudo apt-get install docker-compose

## Run docker compose commands
run docker-compose build
run docker-compose run controller bash


## You should now be in an interactive session on the docker container

### Install ansible-galax add on for dynamic inventory
     ansible-galaxy collection install amazon.aws 
### Edit the aws credentials files add your access_key, secret_key and token
vi ~/.aws/credentials 

### In the workpsace directory where the .tf file are now located in the container
#### Initialize the terraform dir
     terraform init
##### Run the terraform plan
     terraform plan -out=wordpress_plan.txt
##### Apply the plan
run terraform apply "wordpress_plan.txt"

### copy the LB-DNS-NAME into your browser address bar
From the "Outputs" at the end of the execution copy the DNS-NAME for the load balancer and paste
into your browsers address bar.

You should now see the WordPress configuration page

### Destory your aws configuration

Once your are done, run "terraform destroy" to clean up your AWS environment.

If you are done with the Docker container, exit and run "docker-compose down" from your lab instance. 

Done ;)
