#!/sbin/sh

BB="busybox"
ROM=$1

$BB mkdir -p $ROM
chmod 770 $ROM
chown root:root $ROM

exit 0
