#!/bin/bash

DOMAINEJANKINS="https://if108-demo1-eschool.ga/jenkins/"

disable_selinux() {

	sudo setenforce 0
	sudo sed -i -e "s|SELINUX=enforcing|SELINUX=disabled|g" /etc/selinux/config
}

install_soft() {

	sudo timedatectl set-timezone "Europe/Kiev"
    sudo yum install maven wget git mc groovy mlocate -y
	sudo updatedb
}

install_jenkins(){

	sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
	sleep 5
	sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
	sudo yum upgrade -y
	sudo yum install jenkins java-1.8.0-openjdk-devel -y
	sudo sed -i -e 's|JENKINS_ARGS=""|JENKINS_ARGS=\"--prefix=/jenkins\"|g' /etc/sysconfig/jenkins
	sudo systemctl start jenkins
	sleep 10
	sudo systemctl enable jenkins
}

install_config_maven() {

	sudo wget https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp
	sudo tar xf /tmp/apache-maven-3.6.3-bin.tar.gz -C /opt
	sudo ln -s /opt/apache-maven-3.6.3/ /opt/maven

FILE="/etc/profile.d/maven.sh"

/bin/cat <<"EOM" >$FILE
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOM
	sudo chmod +x /etc/profile.d/maven.sh
	source /etc/profile.d/maven.sh
}

create_jenkins_user(){

	sleep 20
	echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", "eschool_admin1238w")' | sudo java -jar /home/al/jenkins/jenkins-cli.jar -s "$DOMAINEJANKINS" -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` groovy =
}

install_jenkins_plugins(){

	sleep 10
	sudo java -jar /home/al/jenkins/jenkins-cli.jar -s $DOMAINEJANKINS -auth admin:eschool_admin1238w install-plugin trilead-api workflow-job cloudbees-folder antisamy-markup-formatter jsch jdk-tool structs workflow-step-api git-client token-macro pipeline-input-step build-timeout credentials plain-credentials pipeline-stage-step ssh-credentials pipeline-graph-analysis credentials-binding git-server scm-api workflow-api branch-api timestamper script-security workflow-support durable-task workflow-durable-task-step jquery3-api pipeline-rest-api snakeyaml-api jackson2-api plugin-util-api echarts-api okhttp-api junit handlebars matrix-project command-launcher momentjs resource-disposer ws-cleanup ant bouncycastle-api github-api ace-editor pipeline-stage-view jquery-detached workflow-scm-step workflow-cps pipeline-milestone-step apache-httpcomponents-client-4-api pipeline-build-step display-url-api git mailer workflow-basic-steps gradle github pipeline-model-api pipeline-model-extensions workflow-cps-global-lib workflow-multibranch pipeline-stage-tags-metadata pipeline-model-definition lockable-resources workflow-aggregator github-branch-source pipeline-github-lib mapdb-api subversion ssh-slaves matrix-auth pam-auth ldap locale ssh-agent authentication-tokens copyartifact publish-over h2-api config-file-provider javadoc maven-plugin pipeline-maven email-ext
	sudo systemctl restart jenkins
}

install_nodejs(){
	sudo curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
	sudo yum clean all && sudo yum makecache fast
	sudo yum install -y gcc-c++ make
	sudo yum install -y nodejs
	sudo npm install -g @angular/cli@7.0.3
	sudo npm install --save-dev --unsafe-perm node-sass
	sudo npm install --save-dev @angular-devkit/build-angular
	npm install primeng --save
    npm install primeicons --save
}

import_jenkins_jobs(){

	java -jar /home/al/jenkins/jenkins-cli.jar -s "$DOMAINEJANKINS" -auth admin:eschool_admin1238w create-job Build_backend_Eschool < /home/al/jenkins/Build_backend_Eschool.xml
	sleep 5
	java -jar /home/al/jenkins/jenkins-cli.jar -s "$DOMAINEJANKINS" -auth admin:eschool_admin1238w create-job Build_frontend_Eschool < /home/al/jenkins/Build_frontend_Eschool.xml
	sleep 5
	java -jar /home/al/jenkins/jenkins-cli.jar -s "$DOMAINEJANKINS" -auth admin:eschool_admin1238w create-job Deploy_backend_Eschool < /home/al/jenkins/Deploy_backend_Eschool.xml
	sleep 5
	java -jar /home/al/jenkins/jenkins-cli.jar -s "$DOMAINEJANKINS" -auth admin:eschool_admin1238w create-job Deploy_frontend_Eschool < /home/al/jenkins/Deploy_frontend_Eschool.xml
}

run_jenkins_jobs(){

	sleep 5
	java -jar /home/al/jenkins/jenkins-cli.jar -s "$DOMAINEJANKINS" -auth admin:eschool_admin1238w build Build_backend_Eschool
	sleep 5
	java -jar /home/al/jenkins/jenkins-cli.jar -s "$DOMAINEJANKINS" -auth admin:eschool_admin1238w build Build_frontend_Eschool
}

add_ssh_keys(){

	sudo mkdir /var/lib/jenkins/.ssh/
	sudo cp /home/al/.ssh/id_rsa /var/lib/jenkins/.ssh/
	sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
}

disable_selinux
install_soft
install_jenkins

install_config_maven

create_jenkins_user
install_jenkins_plugins

install_nodejs

import_jenkins_jobs
run_jenkins_jobs

add_ssh_keys
