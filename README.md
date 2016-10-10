# SoftwareEngineering

## Installation process
* Install [vagrant](https://www.vagrantup.com/downloads.html) and [ruby](https://www.ruby-lang.org/en/documentation/installation/)
* Install librarian-chef with `gem install librarian-chef`
* Download the required chef cookbooks: `librarian-chef install`
* Start virtual machine with `vagrant up` (Note, first time will take a while)
* SSH into the virtual machine with `vagrant ssh` and run `gem install bundler;
    bundle install`

## How to start rails server
    The Rails server is hosted on port 3000. This port is forwarded from the
    virtual machine to the host.
    In order to start the server, cd into the project folder
    and run `rails server -b 0.0.0.0`. Then, you should be able to load the
    root page at localhost:3000.

