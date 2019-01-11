# Nagios Local Build

## Pre-requisite

Setup a VM either via [Vagrant](https://www.vagrantup.com/) or Virtualbox. Below are command instructions with Vagrant.

[Following instruction here to install vagrant](https://www.vagrantup.com/docs/installation/).

Download box file from here 
https://vagrantcloud.com/ubuntu/boxes/xenial64/versions/20190109.0.0/providers/virtualbox.box

Add the following to your `$HOME/Vagrantfile`:

## Ubuntu 16.04

For 16.04, use the following for the `Vagrantfile` setting:

```ruby
Vagrant.configure("2") do |config|
				config.vm.define "Nagios-16.04", autostart: true do |nagios|
					nagios.vm.box = "ubuntu/xenial64"
					nagios.vm.network "private_network", ip: "192.168.101.164"
					nagios.vm.synced_folder ".", "/vagrant"
					nagios.vm.provider "virtualbox" do |vb|
					  vb.memory = 4096
					  vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
					end
				end
			end
```

```bash
vagrant up Nagios-16.04
vagrant ssh Nagios-16.04
sudo mkdir -p /site
sudo chown ubuntu /site
cd /site
git clone https://github.com/preritjain85/Nagios-local.git


# do the make steps ...
make Nagios

## Targets

This builds Nagios inside a local VM.
