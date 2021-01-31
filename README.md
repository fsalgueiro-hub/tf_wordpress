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

run ansible-galaxy collection install amazon.aws 
edit the ~/.aws/credentials file and add your access_key, secret_key and token

cd into tf_WordPress
run terraform init
run terraform plan
run terraform apply -auto-approve

copy the dns name in the ouput and paste to your browser bar
Done ;)
