#!/bin/bash
if [ ! -d /var/run/dbus/ ]
then
	mkdir -p /var/run/dbus/
fi
if [ ! -f /var/run/dbus/system_bus_socket ]
then
        /usr/bin/dbus-daemon --system
fi

/lib/systemd/systemd-udevd &
/usr/bin/startx
