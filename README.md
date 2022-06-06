# OpenHPC Test Cluster Using Rocky Linux 8

This repository provides the utilities necessary for quickly building an OpenHPC
test cluster using VirtualBox VMs and Vagrant.

Hardware Used:

   `Macbook Pro 2019 
   Processor: 2.3 GHz8-Core Intel Core i9
   Memory: 16 GB 2667 MHz DDR4
   `
   
OS Used: 

   `Mac OS Monterey v 12.4`
   
It is recommended to have _at least_ 50 GB of free storage and 16 GB of ram. The installation process was tested on MacOS solely, future fork will be develoed for Linux and Windows. 


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

Look within cluster at `input.local` and change configurations to your liking. 

To start the SMS, run:

    vagrant up ${sms_name}
   
You will get an error in Virtual Box 6.1.34 and with Vagrant version 2.2.17 that ends in "
/sbin/mount.vboxsf: mounting failed with the error: No such device". To fix: 

    vagrant ssh ${sms_name} 
    
    sudo yum -y install perl make gcc kernel-headers-4.18.0-348.20.1.el8_5.x86_64 kernel-devel-4.18.0-348.20.1.el8_5.x86_64 elfutils-libelf-devel
    
    exit
    
You may get an error that yum repo does not contain the kernel-headers and kernel-devel version specified , then you must :

    
       sudo yum install -y wget 
   
    wget https://mirror.tvk.rwth-aachen.de/rocky-linux/8.5/BaseOS/x86_64/os/Packages/k/kernel-devel-4.18.0-348.20.1.el8_5.x86_64.rpm                   https://mirror.tvk.rwth-aachen.de/rocky-linux/8.5/BaseOS/x86_64/os/Packages/k/kernel-headers-4.18.0-348.20.1.el8_5.x86_64.rpm
   
    sudo yum remove -y  kernel-headers-4.18.0-372.9.1.el8.x86_64 kernel-devel-4.18.0-372.9.1.el8.x86_64 
    
    sudo  yum -y install perl make elfutils-libelf-devel

    sudo rpm -i kernel-devel-4.18.0-348.20.1.el8_5.x86_64.rpm  kernel-headers-4.18.0-348.20.1.el8_5.x86_64.rpm
    
    sudo  yum -y install gcc

       
    exit
    
On host machine:
    
    vagrant halt sms 
    
    vagrant up sms --provision
    
What this will do is permit the installation of VirtualBox GuestAdditions. Then installation will continue. 

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

Now run `post-provision.sh` to configure a few things and finally run:

   ```
   vagrant ssh 
   
   bash /test.sh
   ```
   
To tear down the whole system simply use: 

   ``` 
   make clean
   ```
   
Finished ! Have fun using. 

This "app" was developed by Djamil Lakhdar-Hamina of [Research Data and Communications Technology](https://researchdata.us/). 
