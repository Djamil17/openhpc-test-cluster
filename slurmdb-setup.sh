#!/bin/bash
systemctl start slurmdbd
sleep 5
sacctmgr -i add cluster ace-dev
sacctmgr -i add account test
sacctmgr -i add account research
sacctmgr -i add account proj1 parent=research
sacctmgr -i add account proj2 parent=research
sacctmgr -i add user test account=proj1
systemctl start slurmctld
