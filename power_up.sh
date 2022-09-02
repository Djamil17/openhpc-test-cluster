#!/bin/bash
# Example ResumeProgram
echo "`date` Resume invoked $0 $*" >>/var/log/power_save.log
hosts=`scontrol show hostnames $1`
for host in $hosts
do
   sudo scontrol update NodeName=$host State=Resume
done