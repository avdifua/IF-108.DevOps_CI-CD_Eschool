Vagrant.configure("2") do |config|

	config.vm.box = "google/gce"

	config.vm.define :load_balancer do |load_balancer|
	  load_balancer.vm.provider :google do |google, override|
		google.google_project_id = "sofserv-if"
		google.google_json_key_location = "/home/al/Vagrant/sofserv-if-1b4df71ea618.json"
		google.zone = "europe-west3-a"
		google.tags = ['http-server', 'https-server']

		override.vm.provision :shell, path: "load_balancer_nginx.sh"
		override.ssh.username = "al"
		override.ssh.private_key_path = "~/.ssh/virtual_home"

		google.zone_config "europe-west3-a" do |load_balancer_zone|
			load_balancer_zone.name = "eschool-nginx-balancer"
			load_balancer_zone.image_family = "centos-7"
			load_balancer_zone.disk_size = "20"
			load_balancer_zone.external_ip = "34.89.149.154"
			load_balancer_zone.network_ip = "10.156.0.41"
			load_balancer_zone.machine_type = "e2-standard-2"
			load_balancer_zone = "europe-west3-a"
			end
		end
	end

	config.vm.define :db1 do |db1|
	  db1.vm.provider :google do |google, override|
		google.google_project_id = "sofserv-if"
		google.google_json_key_location = "/home/al/Vagrant/sofserv-if-1b4df71ea618.json"
		google.zone = "europe-west3-a"

		override.vm.provision :shell, path: "database_eschool.sh"
		override.ssh.username = "al"
		override.ssh.private_key_path = "~/.ssh/virtual_home"

		google.zone_config "europe-west3-a" do |db1_zone|
			db1_zone.name = "eschool-mysql"
			db1_zone.image_family = "centos-7"
			db1_zone.disk_size = "20"
			db1_zone.network_ip = "10.156.0.11"
			db1_zone.machine_type = "e2-standard-2"
			db1_zone = "europe-west3-a"

			end
		end
	end

	config.vm.define :esc_ba_1 do |eschool_backend_1|
	  eschool_backend_1.vm.provider :google do |google, override|
		google.google_project_id = "sofserv-if"
		google.google_json_key_location = "/home/al/Vagrant/sofserv-if-1b4df71ea618.json"
		google.zone = "europe-west3-a"

		override.vm.provision :shell, path: "backend_eschool.sh"
		override.vm.provision "file", source: "/home/al/Vagrant/CICD_eschool/application_properties/application.properties", destination: "/opt/prod_eschool/application.properties"
		override.ssh.username = "al"
		override.ssh.private_key_path = "~/.ssh/virtual_home"

		google.zone_config "europe-west3-a" do |eschool_backend_1_zone|
			eschool_backend_1_zone.name = "eschool-backend-1"
			eschool_backend_1_zone.image_family = "centos-7"
			eschool_backend_1_zone.disk_size = "20"
			eschool_backend_1_zone.network_ip = "10.156.0.21"
			eschool_backend_1_zone.machine_type = "e2-standard-2"
			eschool_backend_1_zone = "europe-west3-a"
			end
		end
	end

	config.vm.define :esc_ba_2 do |eschool_backend_2|
	  eschool_backend_2.vm.provider :google do |google, override|
		google.google_project_id = "sofserv-if"
		google.google_json_key_location = "/home/al/Vagrant/sofserv-if-1b4df71ea618.json"
		google.zone = "europe-west3-a"

		override.vm.provision :shell, path: "backend_eschool.sh"
		override.vm.provision "file", source: "/home/al/Vagrant/CICD_eschool/application_properties/application.properties", destination: "/opt/prod_eschool/application.properties"
		override.ssh.username = "al"
		override.ssh.private_key_path = "~/.ssh/virtual_home"

		google.zone_config "europe-west3-a" do |eschool_backend_2_zone|
			eschool_backend_2_zone.name = "eschool-backend-2"
			eschool_backend_2_zone.image_family = "centos-7"
			eschool_backend_2_zone.disk_size = "20"
			eschool_backend_2_zone.network_ip = "10.156.0.22"
			eschool_backend_2_zone.machine_type = "e2-standard-2"
			eschool_backend_2_zone = "europe-west3-a"
			end
		end
	end

	config.vm.define :esc_fr_1 do |eschool_frontend_1|
	  eschool_frontend_1.vm.provider :google do |google, override|
		google.google_project_id = "sofserv-if"
		google.google_json_key_location = "/home/al/Vagrant/sofserv-if-1b4df71ea618.json"
		google.zone = "europe-west3-a"

		override.vm.provision :shell, path: "frontend_eschool.sh"
		override.ssh.username = "al"
		override.ssh.private_key_path = "~/.ssh/virtual_home"

		google.zone_config "europe-west3-a" do |eschool_frontend_1_zone|
			eschool_frontend_1_zone.name = "eschool-frontend-1"
			eschool_frontend_1_zone.image_family = "centos-7"
			eschool_frontend_1_zone.disk_size = "20"
			eschool_frontend_1_zone.network_ip = "10.156.0.31"
			eschool_frontend_1_zone.machine_type = "e2-standard-2"
			eschool_frontend_1_zone = "europe-west3-a"
			end
		end
	end

	config.vm.define :esc_fr_2 do |eschool_frontend_2|
	  eschool_frontend_2.vm.provider :google do |google, override|
		google.google_project_id = "sofserv-if"
		google.google_json_key_location = "/home/al/Vagrant/sofserv-if-1b4df71ea618.json"
		google.zone = "europe-west3-a"

		override.vm.provision :shell, path: "frontend_eschool.sh"
		override.ssh.username = "al"
		override.ssh.private_key_path = "~/.ssh/virtual_home"

		google.zone_config "europe-west3-a" do |eschool_frontend_2_zone|
			eschool_frontend_2_zone.name = "eschool-frontend-2"
			eschool_frontend_2_zone.image_family = "centos-7"
			eschool_frontend_2_zone.disk_size = "20"
			eschool_frontend_2_zone.network_ip = "10.156.0.32"
			eschool_frontend_2_zone.machine_type = "e2-standard-2"
			eschool_frontend_2_zone = "europe-west3-a"
			end
		end
	end

	config.vm.define :eschool_cicd do |eschool_cicd|
	  eschool_cicd.vm.provider :google do |google, override|
		google.google_project_id = "sofserv-if"
		google.google_json_key_location = "/home/al/Vagrant/sofserv-if-1b4df71ea618.json"
		google.zone = "europe-west3-a"

		override.vm.provision "file", source: "/home/al/Git/protos-kr/IF-108.DevOps_CI-CD_Eschool/keys_ssh", destination: "/home/al/.ssh"
		override.vm.provision "file", source: "/home/al/Git/protos-kr/IF-108.DevOps_CI-CD_Eschool/jenkins", destination: "/home/al/jenkins"
		override.vm.provision :shell, path: "cicd_eschool.sh"
		override.ssh.username = "al"
		override.ssh.private_key_path = "~/.ssh/virtual_home"

		google.zone_config "europe-west3-a" do |eschool_cicd_zone|
			eschool_cicd_zone.name = "eschool-cicd-jenkins"
			eschool_cicd_zone.image_family = "centos-7"
			eschool_cicd_zone.disk_size = "20"
			eschool_cicd_zone.network_ip = "10.156.0.5"
			eschool_cicd_zone.machine_type = "e2-standard-2"
			eschool_cicd_zone = "europe-west3-a"
			end
		end
	end

end
