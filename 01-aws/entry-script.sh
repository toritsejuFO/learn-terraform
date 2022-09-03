#!/bin/bash
sudo yum -y update && sudo yum -y install httpd
sudo systemctl enable httpd && sudo systemctl start httpd
sudo echo "<h1>Deployed via Terraform</h1>" > /var/www/html/index.html

sudo yum install -y docker
sudo systemctl start docker
sudo docker container run -p 8080:80 nginx
