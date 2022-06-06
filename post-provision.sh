#!/bin/bash
# -----------------------------------------------------------------------------------------
#  Post Installation Script Template
#
#  Please see the OpenHPC Install Guide(s) for more information regarding the
#  procedure. Note that the section numbering included in this script refers to
#  corresponding sections from the companion install guide.
#
#  Where the commands have # in front this means that the #-command was for centos-7.
#  The commands were retained for comparison between the two installations.
# -----------------------------------------------------------------------------------------

set -e
set -x

# ---------------------------- Post OpenHPC Recipe ---------------------------------------
# Commands below are extracted from an OpenHPC install guide recipe and are intended for
# execution on the master SMS host. Plus additional software.
# -----------------------------------------------------------------------------------------

inputFile=/vagrant/input.local

if [ ! -e ${inputFile} ];then
   echo "Error: Unable to access local input file -> ${inputFile}"
   exit 1
else
   . ${inputFile} || { echo "Error sourcing ${inputFile}"; exit 1; }
fi

# Configure systemfiles, insert after end of [Service] block
sed -i '/TasksMax=infinity/Restart=on-failure\nRestartSec=5s\n'/usr/lib/systemd/system/slurmctld.service /usr/lib/systemd/system/slurmdbd.service
systemctl daemon-reload
systemctl restart slurmctld slurmdbd

# Do this after provisioning nodes.
pdsh -w $compute_prefix[1-$num_computes] systemctl enable munge slurmd
pdsh -w $compute_prefix[1-$num_computes] systemctl start munge slurmd
pdsh -w $compute_prefix[1-$num_computes] systemctl sed -i '/TasksMax=infinity/Restart=on-failure\nRestartSec=5s\n'/usr/lib/systemd/system/slurmd.service
pdsh -w $compute_prefix[1-$num_computes] systemctl daemon-reload
pdsh -w $compute_prefix[1-$num_computes] systemctl restart slurmd
pdsh -w $compute_prefix[1-$num_computes] systemctl
pdsh -w $compute_prefix[1-$num_computes] hwclock --systohc
pdsh -w $compute_prefix[1-$num_computes] slurmd
scontrol update NodeName=c[1-$num_computes] State=RESUME

exit 0