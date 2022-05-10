#!/bin/bash
systemctl start slurmdbd
sleep 5
sacctmgr -i add cluster ace-dev
sacctmgr -i add account test
sacctmgr -i add account research
sacctmgr -i add account proj1 parent=research
sacctmgr -i add account proj2 parent=research
sacctmgr -i add user djamil account=proj1
sacctmgr -i add user rodgers account=proj2
sacctmgr -i add user matthew account=proj2
systemctl start slurmctld
