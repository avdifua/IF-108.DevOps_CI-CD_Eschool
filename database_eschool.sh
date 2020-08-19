#!/bin/bash

install_requirements() {

	sudo setenforce 0
	sudo timedatectl set-timezone "Europe/Kiev"
	sudo yum update -y
    sudo yum install wget yum-utils -y
    sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
    sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
    sudo yum-config-manager --enable mysql57-community
    sudo yum install mysql-community-server -y
    sudo service mysqld start
	sleep 10
}

disable_selinux() {

	sudo sed -i -e "s|SELINUX=enforcing|SELINUX=disabled|g" /etc/selinux/config
}

get_temporary_password() {

    string_with_passw=$(sudo cat /var/log/mysqld.log | grep "A temporary")
    temp_pass="${string_with_passw#*localhost: }"
}

setup_mysql() {

sudo su
root_db_pass="kk3iDhwFEZYtJW8="
user_db_pass="cFGc0ulFPkwPyyk="
echo -e "[client]\npassword=$temp_pass" > ~/.my.cnf
mysql -u root --connect-expired-password <<SQL_QUERY
SET PASSWORD = PASSWORD("$root_db_pass");
FLUSH PRIVILEGES;
CREATE DATABASE eschool CHARSET = utf8 COLLATE = utf8_unicode_ci;
CREATE USER 'eschool_user'@'%' IDENTIFIED BY "$user_db_pass";
GRANT ALL PRIVILEGES ON eschool.* TO 'eschool_user'@'%';
FLUSH PRIVILEGES;
SQL_QUERY
}

ssh_keys_add(){

sudo cat <<_EOF >> /home/al/.ssh/authorized_keys
YOUR PUBLIC SSH KEY
_EOF
}

disable_selinux
install_requirements
get_temporary_password
setup_mysql
ssh_keys_add
