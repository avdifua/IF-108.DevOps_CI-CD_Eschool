## Fully automated deploy Eschool application with CI\CD (Jenkins). Frontend web server nginx.
Creation of infrastructure I use vagrant-google.
```This is a Vagrant 2.0.3+ plugin that adds an Google Compute Engine (GCE) provider to Vagrant, allowing Vagrant to control and provision instances in GCE.```

Vagrantfile describes the type of instances, region, network, IP, OS. Bash scripts install and setup required software.

Scheme of infrastructure:

![alt text](https://i.imgur.com/NzR4HMz.jpg)

What you need to change what would run on your machine.

1. Registered domain name. In my case its **if108-demo1-eschool.tk**. Free domaine name you can find here [freenom.com](https://freenom.com).
2. External IP addresses in GCP.
3. Install vagrant-google. How to install and setup detail described here [Vagrant Google Compute Engine (GCE) Provider](https://github.com/mitchellh/vagrant-google)
4. Directory **application_properties**. In this directory file which will be saved on your instance with backend. In this file you have to change:
  - IP your database instance
  - Database username and password
  - Domaine name
5. Directory **jenkins**. Files from this directory will be saved on your CI\CD instance. Here stored **.xml** files with jobs for jenkins.
These jobs will be runs in the end and deploy the application. You have to change only one file **Build_frontend_Eschool.xml**. Replace for your domain.
6. Directory **keys_ssh**. Here stored ssh keys which I generated on the local machine. These keys need for CI\CD instance.
I use rsync for artefacts delivery on backend and frontend. Of course, you can generate your own keys.
7. In bash scripts **cicd_eschool.sh** and **load_balancer_nginx.sh** you have to change the value of the variable **DOMAINE** and **WWWDOMAINE**. Replace for your domain.  
8. In Vagrantfile replace for your external IP address, here: **load_balancer_zone.external_ip = "35.242.219.10"**
