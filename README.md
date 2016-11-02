# SoftwareEngineering

## Installation process
* Install [vagrant](https://www.vagrantup.com/downloads.html) and [ruby](https://www.ruby-lang.org/en/documentation/installation/)
    * Vagrant is a virtual machine manager and ruby is the language/interpreter
* Install librarian-chef with `gem install librarian-chef`
    * librarian-chef manages chef cookbooks. These cookbooks are used to
        install dependencies on the VM.
* Download the required chef cookbooks: `librarian-chef install`
    * This downloads the cookbooks.
* Start virtual machine with `vagrant up` (Note, first time will take a while)
    * This will initially download the base box and run the provisioning
        scripts. This installs things from the cookbooks as well as whatever
        else is listed in the `Vagrantfile`.
* SSH into the virtual machine with `vagrant ssh` and run
    `gem install bundler; rbenv rehash; bundle install` from the rails project
    directory.
    * Ruby libaries/dependencies are managed using RubyGems via the `gem` command. `bundler`
        installs ruby dependencies for a specific project. `rbenv` manages ruby
        verions. `gem install bundler` installs Bundler. `rbenv rehash` is run
        whenever gems that install new commands are added. `bundle install`
        installs all the gem dependencies for a project.

## How to start rails server
    The Rails server is hosted on port 3000. This port is forwarded from the
    virtual machine to the host.
    In order to start the server, cd into the project folder
    and run `rails server -b 0.0.0.0`. Then, you should be able to load the
    root page at localhost:3000.

## How to deploy
* Deployment works by pulling down the lastest version of the master from
    Github and deploying it to the main node. This is done with `cap production
    deploy` from within the vm.
* Note: you must have the identity file for the server as well as your Github private key
    added to your ssh agent in order to connect to the box. The server private
    key is to access to server obviously, and the Github private key is to pull
    down the most recent copy of master from Github.
    To ssh into the vagrant machine, you must run `vagrant ssh -- -A`.
    This forwards your ssh agent to the vagrant machine. Capistrano (cap)
    forwards your ssh-agent to the remote server when it tries to connect,
    hence why it can access the github repo.
* The server should update automatically. If it crashes, you might have to
    restart the puma server. (TODO: make this more robust)

## Master setup
* Open up ports 22, 80, and 443 for outside access
* Clone project repo to home directory of ubuntu user
* Install ruby, nginx, curl, wget: `sudo apt-get ruby nginx curl wget`
* Install
    [chef-solo](http://gettingstartedwithchef.com/first-steps-with-chef.html)
* Install librarian-chef and `librarian-chef install` to download cookbooks
* `sudo apt-get install sqlite libsqlite3-dev`
* `sudo chef-solo -c solo.rb -j node.json`
* Start puma server inside of screen session `bundle exec puma -b
    'unix:///home/ubuntu/apps/se_filesystem/shared/tmp/sockets/puma.sock' -e
    production --control
    'unix:///home/ubuntu/apps/se_filesystem/shared/tmp/sockets/pumactl.sock' -S
    /home/ubuntu/apps/se_filesystem/shared/tmp/pids/puma.state`
    (Move this into an init script)
