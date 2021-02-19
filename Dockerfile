# Centos & Python
FROM centos
# Install the required pacakes
RUN yum update -y && yum install -y git python3 wget unzip

# Download and install terraform
RUN wget https://releases.hashicorp.com/terraform/0.14.5/terraform_0.14.5_linux_amd64.zip && \
    unzip terraform_0.14.5_linux_amd64.zip && \
    mv terraform /usr/local/bin/.
RUN mkdir -p /etc/ansible/inventory
COPY ansible.cfg /etc/ansible/
COPY tf_aws_ec2.yml /etc/ansible/inventory/
# Create user and copy files
RUN useradd -ms /bin/bash tform && \
    mkdir /home/tform/workspace
COPY credential_aws.txt /home/tform/.aws/credentials
COPY config_aws.txt /home/tform/.aws/config
ADD ./tf_WordPress /home/tform/workspace/ 
RUN chown -R tform /home/tform/workspace && \
    chown -R tform /home/tform/.aws
USER tform
WORKDIR /home/tform/workspace
# Install awscli/ansible/boto3
RUN pip3 install awscli --user && \
    pip3 install ansible --user && \
    pip3 install boto3 --user && \
    ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
