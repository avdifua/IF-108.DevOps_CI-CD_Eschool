#!/bin/bash

install_soft() {

	setenforce 0
	sudo timedatectl set-timezone "Europe/Kiev"
	sudo yum update -y
    sudo yum install wget git gcc nginx mc -y
	sudo systemctl enable nginx
    sudo systemctl start nginx
}

install_inotify-tools() {

	cd /home/
	wget https://github.com/inotify-tools/inotify-tools/releases/download/3.20.2.2/inotify-tools-3.20.2.2.tar.gz
	sudo tar xfv inotify-tools-3.20.2.2.tar.gz
	cd inotify-tools-3.20.2.2
	sudo ./configure --prefix=/usr --libdir=/lib64 && make && su -c 'make install'
}

setup_cicd_work_dir(){

	sudo mkdir -p /opt/frontend_eschool/www_frontend/dist/eSchool
	mkdir /opt/frontend_eschool/tar
}

setup_virtual_host() {

FILE="/etc/nginx/conf.d/frontend.conf"

sudo cat <<_EOF >$FILE
server {
    server_name localhost;
    root /var/www/eSchool;
    location ~ ^(.*)$ { }
    location / {
       rewrite ^(.*)$ /index.html;
   }
}
_EOF

	sudo mkdir /var/www
	sudo ln -s /opt/frontend_eschool/www_frontend/dist/eSchool /var/www
	sudo sed -i -e "s|default_server;|;|g" /etc/nginx/nginx.conf
	sudo chown -R nginx:nginx /opt/frontend_eschool/www_frontend/
	sudo chmod 766 -R /opt/frontend_eschool/www_frontend/
	sudo systemctl restart nginx
}

systemd_watcher_service(){

	FILE="/etc/systemd/system/watch_frontend_eschool.service"

sudo cat <<_EOF >$FILE
[Unit]
Description=Watch frontend eschool app service

[Service]
WorkingDirectory=/opt/frontend_eschool
ExecStart=/bin/bash watch_frontend.sh
User=al
Type=simple
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target

_EOF
}

watch_frontend_script(){

	FILE="/opt/frontend_eschool/watch_frontend.sh"

sudo cat <<"_EOF" >$FILE
#!/bin/bash

SRC_DIR="/opt/frontend_eschool/tar"

make_action(){

sudo tar -xf /opt/frontend_eschool/tar/backend_eschool_full.tar.gz -C www_frontend
sudo chown -R nginx:nginx /opt/frontend_eschool/www_frontend
sudo chmod 766 -R /opt/frontend_eschool/www_frontend
sudo systemctl restart watch_frontend_eschool
}

IFS='
'
inotifywait --format '%w %f' -m -r $SRC_DIR |\
(
while read
do
DIR="${REPLY%% *}"
FILE="${REPLY##* }"
make_action
done
)
_EOF

    sudo chmod +x /opt/frontend_eschool/watch_frontend.sh
}

up_service(){

    sudo chown -R nginx:nginx /opt/frontend_eschool
    sudo systemctl daemon-reload
    sudo systemctl enable watch_frontend_eschool
    sudo systemctl start watch_frontend_eschool
}

ssh_pub_key(){

	FILE="/home/al/.ssh/authorized_keys"

sudo cat <<_EOF >>$FILE
YOUR PUBLIC SSH KEY
_EOF
}

install_soft
install_inotify-tools

setup_cicd_work_dir

setup_virtual_host
systemd_watcher_service
watch_frontend_script

up_service
ssh_pub_key
