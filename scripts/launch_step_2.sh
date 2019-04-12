#!/bin/bash
SCRIPT=/root/launch_step_3.sh
wget -O $SCRIPT https://raw.githubusercontent.com/vakwetu/encryption-workshop/master/scripts/launch_step_3.sh
chmod +x $SCRIPT
. $SCRIPT > /root/setup_go.log
echo Done!
