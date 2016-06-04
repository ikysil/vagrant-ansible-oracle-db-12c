# -*- mode: ruby -*-
# vi: set ft=ruby :

unless Vagrant.has_plugin?("vagrant-hostmanager")
  raise "Please install vagrant-hostmanager with \nvagrant plugin install vagrant-hostmanager"
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
#  config.vm.box = "boxcutter/centos72"
  config.vm.box = "boxcutter/centos67"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.ignore_private_ip = false
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    # set auto_update to false, if you do NOT want to check the correct
    # additions version when booting this machine
    config.vbguest.auto_update = false
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.define "oradb3" do |oradb3|
    oradb3.vm.network "private_network", ip: "10.100.0.3"
    oradb3.vm.hostname = "oradb3.private"
    oradb3.vm.provider "virtualbox" do |vb|
      vb.memory = "2560"
      vb.cpus = 2
      vb.name = "oradb12c"

      # bad I/O performance with Linux host otherwise
      vb.customize ["storagectl", :id, "--name", "SATA Controller", "--hostiocache", "on"]

      # dbca will not finish when executed on CentOS 7 otherwise
      vb.customize ["modifyvm", :id, "--paravirtprovider", "none"]

      vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]
      vb.customize ["modifyvm", :id, "--chipset", "ich9"]
    end
  end

  config.vm.define "installer", autostart: false do |installer|
    installer.vm.network "private_network", ip: "10.100.0.2"
    installer.vm.hostname = "installer.private"
    installer.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 1
      vb.name = "oradb12c-installer"

      vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]
    end

    installer.vm.provision "shell", privileged: true, inline: <<-SHELL
      yum install -y epel-release
      yum install -y ansible
    SHELL

    installer.vm.provision "shell", inline: <<-SHELL
      export PYTHONUNBUFFERED=1
      export ANSIBLE_FORCE_COLOR=true
      cd /vagrant
      ansible-playbook oracle-db.yml -v -i hosts
    SHELL
  end

end
