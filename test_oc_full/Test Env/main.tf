provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.4.0"
  # insert the 34 required variables here


  name = "bastion-host"

  ami                    = "ami-03fa4afc89e4a8a09"
  instance_type          = "t2.micro"
  key_name               = "bastion-key"
  monitoring             = true
  vpc_security_group_ids = ["sg-0d3fc4c1216ee1e12"]
  subnet_id              = "subnet-f0092998"

  user_data = <<EOF
    #!/bin/bash
    
    sudo mkdir /root/openshift 
    sudo mkdir /home/ec2-user/oc-defaults 
    sudo wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-install-linux.tar.gz -P /home/ec2-user/oc-defaults 
    sudo wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz -P /home/ec2-user/oc-defaults/ 
    sudo tar xvf /home/ec2-user/oc-defaults/openshift-install-linux.tar.gz --directory=/home/ec2-user/oc-defaults -C /root/openshift 
    sudo tar xvf /home/ec2-user/oc-defaults/openshift-client-linux.tar.gz --directory=/home/ec2-user/oc-defaults -C /root/openshift
    ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_rsa
    sudo cp /root/openshift/oc /usr/bin && sudo cp /root/openshift/kubectl /usr/bin
    
    EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
