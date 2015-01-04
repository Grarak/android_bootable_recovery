#!/sbin/sh

BB="busybox"

ROM=$1

$BB mkdir -p $ROM
$BB chmod 770 $ROM
$BB chown root:root $ROM
