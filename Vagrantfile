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
  config.vm.box = "boxcutter/centos72"
#  config.vm.box = "boxcutter/centos67"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  config.vm.network "private_network", ip: "192.168.56.13"
  config.vm.hostname = "oradb3.private"

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.ignore_private_ip = false
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    # set auto_update to false, if you do NOT want to check the correct
    # additions version when booting this machine
    config.vbguest.auto_update = false
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
    vb.name = "oradb12c"

    # bad I/O performance with Linux host otherwise    
    vb.customize ["storagectl", :id, "--name", "SATA Controller", "--hostiocache", "on"]

    # dbca will not finish when executed on CentOS 7 otherwise
    vb.customize ["modifyvm", :id, "--paravirtprovider", "none"]

    vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]
    vb.customize ["modifyvm", :id, "--chipset", "ich9"]
  end

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
#    config.cache.synced_folder_opts = {
#      type: :nfs,
#      # The nolock option can be useful for an NFSv3 client that wants to avoid the
#      # NLM sideband protocol. Without this option, apt-get might hang if it tries
#      # to lock files needed for /var/cache/* operations. All of this can be avoided
#      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
#      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
#    }
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    sudo yum install -y epel-release
    sudo yum install -y ansible1.9
  SHELL

  config.vm.provision "guest_ansible" do |ansible|
    ansible.playbook = "oracle-db.yml"
    ansible.inventory_path = "hosts"
    ansible.limit = 'all'
  end
end
