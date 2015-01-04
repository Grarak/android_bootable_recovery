#!/sbin/sh

BB="busybox"
MOUNT="busybox mount"
UMOUNT="busybox umount -l"

ROMPATH=$1

[ -d /.firstdata ] && ROMPATH=`echo $ROMPATH | sed 's|/sdcard/.romswitcher|/.firstdata/media/.romswitcher|g'`

if [ -d ${ROMPATH}system ]; then

	rm -rf ${ROMPATH}system/*
	rm -rf ${ROMPATH}system/.*

else

	$UMOUNT /system
	$BB mkdir -p /system

	$MOUNT -t ext4 -o rw ${ROMPATH}system.img /system || exit 1
	$BB rm -rf /system/*
	$BB rm -rf /system/.*

fi

exit 0
