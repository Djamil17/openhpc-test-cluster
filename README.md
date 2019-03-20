# OpenHPC Test Cluster

This repository provides the utilities necessary for quickly building an OpenHPC
test cluster using VirtualBox VMs and Vagrant.

## Prerequisites

Install the following software.

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [VirtualBox Oracle VM VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/)

## Running

To build and run the SMS, run `vagrant up`. Once built, you can run `vagrant
ssh` to SSH into the SMS. Run `vagrant up c1` and `vagrant up c2` to bring up
the two included compute nodes. They will be automatically provisioned by the
SMS. Run `vagrant halt` to stop the VMs and `vagrant destroy` to clean up.
