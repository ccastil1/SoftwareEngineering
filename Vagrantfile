# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/xenial64"
    master.vm.network 'forwarded_port', guest: 3000, host: 3000
    master.vm.network 'private_network', ip: '10.10.10.10'
  end

  config.vm.define "file_node" do |file_node|
    file_node.vm.box = "ubuntu/xenial64"
    file_node.vm.network 'forwarded_port', guest: 3001, host: 3001
    file_node.vm.network 'private_network', ip: '10.10.10.11'
  end


  config.vm.synced_folder '.', '/home/ubuntu/se_filesystem'

  config.vm.provision(
    'shell',
    inline: 'sudo apt-get update; sudo apt-get -y install libssl-dev zlib1g-dev'
  )
  config.vm.provision 'chef_solo' do |chef|
    chef.add_recipe 'openssl'
    chef.add_recipe 'readline'
    chef.add_recipe 'nodejs'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::vagrant'
    chef.add_recipe 'rbenv::user'
    chef.add_recipe 'postgresql::server'
    chef.json = {
      'rbenv' => {
        'user_installs' => [
          {
            'user' => 'ubuntu',
            'rubies' => ['2.3.1'],
            'global' => '2.3.1',
            'gems' => {
              '2.3.1' => [
              ]
            }
          }
        ]
      },
      'postgresql' => {
        'password'=> {
          'postgres' => 'postgres'
        }
      }
    }
  end
end
