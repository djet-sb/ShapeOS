#!/bin/sh
su -c '/usr/bin/X' ${USER} &
#!!!! Need fix it
sleep 5
su -c '/usr/bin/i3' ${USER}
