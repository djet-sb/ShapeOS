#!/bin/bash
if [ ! -d /var/run/dbus/ ]
then
	mkdir -p /var/run/dbus/
fi
if [ ! -f /var/run/dbus/system_bus_socket ]
then
        /usr/bin/dbus-daemon --system &
	udevadm monitor --kernel --env &
	udevadm monitor --udev --env &
fi

/lib/systemd/systemd-udevd &
/usr/bin/startx &
udevadm trigger --action=change
tail -f /dev/null
