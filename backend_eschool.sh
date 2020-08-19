#!/bin/bash

install_soft() {

	sudo setenforce 0
	sudo timedatectl set-timezone "Europe/Kiev"
	sudo yum update -y
	sudo yum install java-1.8.0-openjdk wget git gcc mc maven -y
	sudo su
}

install_inotify-tools() {

	cd /home
	wget https://github.com/inotify-tools/inotify-tools/releases/download/3.20.2.2/inotify-tools-3.20.2.2.tar.gz
	sudo tar xfv inotify-tools-3.20.2.2.tar.gz
	cd inotify-tools-3.20.2.2
	sudo ./configure --prefix=/usr --libdir=/lib64 && make && su -c 'make install'
}

install_maven() {

	cd /home/
	sudo wget https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp
	sudo tar xf /tmp/apache-maven-3.6.3-bin.tar.gz -C /opt
	sudo ln -s /opt/apache-maven-3.6.3/ /opt/maven
}

setup_maven() {

	FILE="/etc/profile.d/maven.sh"

/bin/cat <<EOM >$FILE
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOM
	sudo chmod +x /etc/profile.d/maven.sh
	source /etc/profile.d/maven.sh
}

setup_cicd_work_dir(){

	sudo mkdir -p /opt/prod_eschool/Ci_Cd
}

systemd_eschool_service() {

	FILE="/etc/systemd/system/eschool_backend.service"

sudo cat <<_EOF >$FILE
[Unit]
Description=Run backend Eschool app as service.

[Service]
WorkingDirectory=/opt/prod_eschool
ExecStart=/bin/java -jar /opt/prod_eschool/eschool.jar --spring.config.location=file:///opt/prod_eschool/application.properties
User=al
Type=simple
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
_EOF
}

systemd_watcher_service(){

	FILE="/etc/systemd/system/watch_backend_eschool.service"

sudo cat <<_EOF >$FILE
[Unit]
Description=Watch directory eschool app as service.

[Service]
WorkingDirectory=/opt/prod_eschool
ExecStart=/bin/bash watch_eschool_jar.sh
User=al
Type=simple
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
_EOF
}

watch_eschool_jar_script(){

	FILE="/opt/prod_eschool/watch_eschool_jar.sh"

cat <<"_EOF" >$FILE
#!/bin/bash

SRC_DIR="/opt/prod_eschool/Ci_Cd/"
DST_DIR="/opt/prod_eschool"

make_action(){

DIR_TO_COPY_TO=${1/${SRC_DIR}/${DST_DIR}}
mv $1$2 $DIR_TO_COPY_TO
sudo systemctl restart eschool_backend
}

IFS='
'
inotifywait --format '%w %f' --include '.*\.jar$' -m -r $SRC_DIR |\
(
while read
do
DIR="${REPLY%% *}"
FILE="${REPLY##* }"
echo $FILE
make_action $DIR $FILE
done
)
_EOF

	sudo chmod +x /opt/prod_eschool/watch_eschool_jar.sh
}

ssh_pub_key(){

	FILE="/home/al/.ssh/authorized_keys"

sudo cat <<_EOF >>$FILE
YOUR PUBLIC SSH KEY
_EOF
}

up_service(){

    sudo chown -R al:al /opt/prod_eschool
    sudo systemctl daemon-reload
    sudo systemctl enable eschool_backend
    sudo systemctl enable watch_backend_eschool
    sudo systemctl start eschool_backend
    sudo systemctl start watch_backend_eschool
}

install_soft
install_inotify-tools
install_maven

setup_maven
setup_cicd_work_dir

systemd_eschool_service
systemd_watcher_service

watch_eschool_jar_script
ssh_pub_key
up_service
