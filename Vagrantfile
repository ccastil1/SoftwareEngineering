# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.box = 'ubuntu/xenial64'
  config.vm.network 'forwarded_port', guest: 3000, host: 3000

  config.vm.synced_folder 'se_filesystem', '/home/ubuntu/se_filesystem'

  config.vm.provision(
    'shell',
    inline: 'sudo apt-get update; sudo apt-get -y install libssl-dev zlib1g-dev'
  )
  config.vm.provision(
    'shell',
    inline: 'sudo mkdir /var/lib/se_app; sudo chown ubuntu:ubuntu /var/lib/se_app'
  )
  config.vm.provision 'chef_solo' do |chef|
    chef.add_recipe 'readline'
    chef.add_recipe 'nodejs'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::vagrant'
    chef.add_recipe 'rbenv::user'
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
      }
    }
  end
end
