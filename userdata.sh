#!/bin/bash
sudo yum update -y

sudo yum install -y git docker go vi jq mc
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sudo yum install bash-completion
sudo source /usr/share/bash-completion/bash_completion

#----- Docker\Docker-compose install -----#
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) 
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker jenkins

#----- Jenkins install -----#
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install java-17-amazon-corretto -y
sudo yum install jenkins -y

sudo sed -i 's/8080/80/g' /usr/lib/systemd/system/jenkins.service
sudo sed -i 's/#AmbientCapabilities=CAP_NET_BIND_SERVICE/AmbientCapabilities=CAP_NET_BIND_SERVICE/g' /usr/lib/systemd/system/jenkins.service
sudo systemctl daemon-reload

sudo systemctl enable jenkins
sudo systemctl start jenkins

sleep 60
sudo reboot
