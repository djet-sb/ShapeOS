#!/bin/sh
su -c '/usr/bin/X' ${USER} &
su -c '/usr/bin/i3' ${USER}
