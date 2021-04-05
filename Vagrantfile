# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.2.9"

Vagrant.configure("2") do |config|

  config.vagrant.plugins = {"vagrant-env" => {"version" => "0.0.3"}}

  config.vm.define "laprimaire_2022" do |host|
    host.vm.box = "ubuntu/focal64"
    host.vm.hostname = "2022.laprimaire.org.test"
    host.vm.network "private_network", ip: "192.168.142.2"

    host.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end

  config.vm.define "ansible" do |host|
    host.vm.box = "ubuntu/focal64"
    host.vm.synced_folder ".", "/vagrant", mount_options: ['dmode=775,fmode=700']

    host.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    host.env.enable

    host.vm.provision "shell", path: "./script/install_ansible.sh"

    host.vm.provision "ansible_local" do |ansible|
      ansible.version = "2.9.0"
      ansible.install = false
      ansible.verbose = 'v'
      ansible.limit = ENV['ANSIBLE_LIMIT'] || "all"
      ansible.raw_arguments = ENV['ANSIBLE_EXTRA_ARGS']
      ansible.config_file = "provisioning/ansible.cfg"
      ansible.playbook = "provisioning/playbook.yml"
      ansible.inventory_path = "provisioning/hosts.yml"
      ansible.become = true
      ansible.playbook_command = "/vagrant/script/ansible-playbook.sh"
      ansible.extra_vars = {
        ansible_ssh_user: "vagrant",
        base_hostname: "laprimaire.org.test"
      }
    end
  end

end
