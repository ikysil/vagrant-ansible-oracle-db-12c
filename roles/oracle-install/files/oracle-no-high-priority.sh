#!/bin/bash

. /home/oracle/.bashrc

sqlplus / as sysdba << EOF
alter system set "_high_priority_processes"='' scope=spfile;
alter system set "_highest_priority_processes"='' scope=spfile;
/
EOF
