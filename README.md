# OpenHPC Test Cluster

This repository provides the utilities necessary for quickly building an OpenHPC
test cluster using VirtualBox VMs and Vagrant.

Hardware Requirements 

   It is recommended to have _at least_ 50 gb of storage and 16 gb of ram. The installation process was tested on mac, windows, and linux ubuntu. 


# Mac OS installation 

## Prerequisites 

Install the following software.

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [VirtualBox Oracle VM VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/)

## Installing vagrant plugins 

Download vagrant box and plugins 

    vagrant plugin install vagrant-vbguest 
    
    vagrant plugin install vagrant-disksize

## Building and Running

To build a cluster of `$N` nodes, where `1 <= $N <= 10`, run:

    make NCOMPUTES=$N

A directory named `cluster` will be built. Change into the `cluster` directory
before running subsequent commands.

To start the SMS, run:

    vagrant up
   
You will get an error in Virtual Box 6.1.34 and with Vagrant version 2.2.17 that ends in "
/sbin/mount.vboxsf: mounting failed with the error: No such device". To fix: 

    vagrant ssh ${sms_name} 
    
    sudo yum -y install perl gcc kernel-headers-4.18.0-348.20.1.el8_5.x86_64 kernel-devel-4.18.0-348.20.1.el8_5.x86_64 elfutils-libelf-devel
    
    exit

On host machine:
    
    vagrant halt 
    
    vagrant up ${sms_name} --provision

What this will do is permit the installation of VirtualBox GuestAdditions. 

Provisioning the first time will take approximately ten minutes. Once the SMS is
running, you can SSH into it:

    vagrant ssh

If you are doing Slurm development, you can run the following script to start up
Slurm and establish some default accounting settings.

    /vagrant/slurm-setup.sh

Compute nodes are named `c1`, `c2`, ..., `c$N`. For any given compute node, say
`c$i`, you can start it with:

    vagrant up c$i

When booting compute nodes, Vagrant will be unable to communicate with them as
they only have an internal network. Ignore the error message Vagrant spits out
after 10 seconds of booting. The SMS will provision the compute nodes, which
will take approximately two minutes.

The ordinary Vagrant `halt`, `destroy`, and `status` commands may be useful as
well.

# Ubuntu Linux installation 
