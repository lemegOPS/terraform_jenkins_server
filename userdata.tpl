#!/bin/bash
sudo yum update -y

sudo yum install -y git docker go vi jq mc epel-release
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sudo yum install bash-completion
sudo source /usr/share/bash-completion/bash_completion
sudo amazon-linux-extras install -y epel

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

## sudo sed -i 's/8080/80/g' /usr/lib/systemd/system/jenkins.service
sudo sed -i 's/#httpListenAddress=127.0.0.1/httpListenAddress=127.0.0.1/g' /usr/lib/systemd/system/jenkins.service
## sudo sed -i 's/#AmbientCapabilities=CAP_NET_BIND_SERVICE/AmbientCapabilities=CAP_NET_BIND_SERVICE/g' /usr/lib/systemd/system/jenkins.service
sudo systemctl daemon-reload

sudo systemctl enable jenkins
sudo systemctl start jenkins

#----- Nginx install -----#
sudo yum install -y nginx certbot python-certbot-nginx
sudo systemctl start nginx
sudo systemctl enable nginx

cat <<EOF | sudo tee /etc/nginx/conf.d/${subdomain}.${route53_zone}.conf
server {
    listen 80;
    server_name ${subdomain}.${route53_zone};

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo nginx -s reload
sudo systemctl restart nginx
sleep 10
sudo certbot --nginx -d ${subdomain}.${route53_zone} -m ${certbot_email} --non-interactive --agree-tos
sleep 10
sudo reboot