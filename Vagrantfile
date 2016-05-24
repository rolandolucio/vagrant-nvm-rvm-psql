# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, path: "swap.sh"
  config.vm.provision :shell, path: "install-nvm.sh", args: "v0.31.1", privileged: false
  config.vm.provision :shell, path: "install-node.sh", args: "0.10", privileged: false
  config.vm.provision :shell, path: "install-rvm.sh", args: "stable", privileged: false
  config.vm.provision :shell, path: "install-ruby.sh", args: "ruby-1.9.3-p551", privileged: false
  config.vm.provision :shell, path: "postgres.sh"
  config.vm.provision :shell, path: "extras.sh"




  config.vm.synced_folder "sync/", "/home/vagrant/sync"

  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 4000, host: 4000
  config.vm.network "forwarded_port", guest: 5432, host: 15432



end
