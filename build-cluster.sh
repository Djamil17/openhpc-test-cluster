#!/bin/bash

RESIZE_SCRIPT= << SCRIPT
yum install -y cloud-utils-growpart

growpart /dev/sda 1

xfs_growfs /dev/sda1
SCRIPT

vdi_dir=$(pwd)

NCOMPUTES="$1"
if [ -z "$NCOMPUTES" ] || [ "$NCOMPUTES" -lt 1 ] || [ "$NCOMPUTES" -gt 10 ]; then
    echo "You must request between 1 and 10 compute nodes ($NCOMPUTES requested)."
    exit 1
fi

PXEBOOT_ISO="$2"
if [ ! -f "$PXEBOOT_ISO" ]; then
    echo "You must supply a PXEBOOT ISO that exists."
    exit 1
fi

COMPUTE_DEFS=""
VAGRANT_DEFS=""
for ((i=1;i<=NCOMPUTES;i++)); do
    COMPUTE_DEFS+=`cat <<EOF
c_name[$((i-1))]=c$i
c_ip[$((i-1))]=192.168.7.$((i+2))
c_mac[$((i-1))]=22:1a:2b:00:00:$((i-1))$((i-1))
EOF`
    COMPUTE_DEFS+=$'\n'
    VAGRANT_DEFS+=`cat <<EOF
    config.vm.define "c$i", autostart: false do |c$i|
       c$i.vm.provider "virtualbox" do |vboxc$i|
        vboxc$i.memory = 2048
        vboxc$i.cpus = 1
        # Enable if you need to debug PXE.
        vboxc$i.gui = 'true'


        ## sometimes vdi is not created, need to create VDI and attach it to the new machine so uncomment here

#          vboxc$i.customize [
#          "createmedium", "disk",
#          "--filename","c${i}",
#          "--format", "vdi",
#          "--size", "15360"]
#
#          vboxc$i.customize [
#          "storageattach", :id,
#          "--storagectl", "IDE Controller",
#          "--type", "hdd",
#          "--port", "1",
#          "--device", "1",
#
#          ## define a better location
#          "--medium","/c${i}.vdi"
#
#           ]

        vboxc$i.customize [
          'modifyvm', :id,
          '--nic1', 'intnet',
          '--intnet1', 'provisioning',
          '--boot1', 'dvd',
          '--boot2', 'none',
          '--boot3', 'none',
          '--boot4', 'none',
          '--macaddress1', '221a2b0000$((i-1))$((i-1))'
        ]

        vboxc$i.customize [
          "storageattach", :id,
          "--storagectl", "IDE Controller",
          "--port", "0",
          "--device", "0",
          "--type", "dvddrive",
          "--medium", "${PXEBOOT_ISO}"
        ]

      end
      c$i.vm.boot_timeout = 10

    end
EOF`
    VAGRANT_DEFS+=$'\n'
done

cp recipe.sh.tmpl cluster/recipe.sh
sed "s/<NCOMPUTES>/$NCOMPUTES/g;" input.local.tmpl > cluster/input.local
echo "$COMPUTE_DEFS" >> cluster/input.local
cp Vagrantfile.header.tmpl cluster/Vagrantfile
echo "$VAGRANT_DEFS" >> cluster/Vagrantfile
cat Vagrantfile.footer.tmpl >> cluster/Vagrantfile
cp resize-disk.sh cluster/resize-disk.sh
cp slurm.conf cluster/slurm.conf
cp sshd_config cluster/sshd_config
cp slurmdbd.conf cluster/slurmdbd.conf
cp slurmdb.sql cluster/slurmdb.sql
cp slurmdb-setup.sh cluster/slurmdb-setup.sh
cp cgroup.conf cluster/cgroup.conf
cp cgroup_allowed_devices_file.conf cluster/cgroup_allowed_devices_file.conf
cp post-provision.sh cluster/post-provision.sh

cp "$PXEBOOT_ISO" "cluster/$PXEBOOT_ISO"
