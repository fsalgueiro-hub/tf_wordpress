# Centos & Python
FROM centos
# Install the required pacakes
RUN yum update -y
RUN yum install -y git
RUN yum install -y python3
RUN yum install -y wget
RUN yum install -y unzip
# Download and install terraform
RUN wget https://releases.hashicorp.com/terraform/0.14.5/terraform_0.14.5_linux_amd64.zip
RUN unzip terraform_0.14.5_linux_amd64.zip
RUN mv terraform /usr/local/bin/.
RUN mkdir /etc/ansible
COPY ansible.cfg /etc/ansible/
RUN mkdir /etc/ansible/inventory
COPY tf_aws_ec2.yml /etc/ansible/inventory/
# Create user and copy files
RUN useradd -ms /bin/bash tform
RUN mkdir /home/tform/workspace
COPY requirements.txt /home/tform/workspace/
COPY credential_aws.txt /home/tform/.aws/credetials
COPY config_aws.txt /home/tform/.aws/config_aws
ADD ./tf_WordPress /home/tform/workspace/ 
USER tform
RUN chown -R tform /home/tform/workspace
RUN chown -R tform /home/tform/.aws
WORKDIR /home/tform/workspace
# Install awscli/ansible/boto3
RUN pip3 install awscli --user
RUN pip3 install ansible --user
RUN pip3 install boto3 --user
# Create an SSH key
RUN ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
# Install ansible galaxy
# RUN ansible-galaxy collection install amazon.aws





