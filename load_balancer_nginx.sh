#!/bin/bash

DOMAINE="if108-demo1-eschool.ga"
WWWDOMAINE="www.if108-demo1-eschool.ga"

install_soft() {

    sudo timedatectl set-timezone "Europe/Kiev"
    sudo setenforce 0
    sudo yum update -y
    sudo yum install nginx certbot python2-certbot-nginx -y
    sudo systemctl enable nginx
    sudo systemctl start nginx
}

disable_selinux() {

	sudo setenforce 0
	sudo sed -i -e "s|SELINUX=enforcing|SELINUX=disabled|g" /etc/selinux/config
}

config_virtual_host() {

FILE="/etc/nginx/conf.d/eSchool.conf"

/bin/cat <<EOM >$FILE
upstream backend {
    ip_hash;
    server 10.156.0.21:8080;
    server 10.156.0.22:8080;
}

upstream frontend {
    ip_hash;
    server 10.156.0.31;
    server 10.156.0.32;
}

server {
    server_name $DOMAINE $WWWDOMAINE;
    location / {
    	proxy_pass http://frontend;
}
    location ^~ /jenkins/ {

    proxy_pass http://10.156.0.5:8080/jenkins/;

    proxy_redirect http:// https://;

    sendfile off;

    proxy_set_header   Host             \$host:\$server_port;
    proxy_set_header   X-Real-IP        \$remote_addr;
    proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;

    proxy_max_temp_file_size 0;

    client_max_body_size       10m;
    client_body_buffer_size    128k;

    proxy_connect_timeout      90;
    proxy_send_timeout         90;
    proxy_read_timeout         90;

    proxy_temp_file_write_size 64k;

    proxy_http_version 1.1;
    proxy_request_buffering off;
    proxy_buffering off; # Required for HTTP-based CLI to work over SSL
    }
}
EOM
    sudo sed -i -e "s|default_server;|;|g" /etc/nginx/nginx.conf
    sudo systemctl restart nginx
}

install_cert() {

    sudo certbot --agree-tos --nginx --register-unsafely-without-email  -d $DOMAINE -d $WWWDOMAINE

FILE="/etc/nginx/conf.d/eSchool.conf"
/bin/cat <<EOM >>$FILE

server {
    listen 8080 default_server ssl;
    location / {
    proxy_pass http://backend;
}

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/$DOMAINE/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/$DOMAINE/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
EOM

    sudo systemctl restart nginx
}

install_soft
disable_selinux
config_virtual_host
install_cert
