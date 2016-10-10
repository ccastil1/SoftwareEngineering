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

