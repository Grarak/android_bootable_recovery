#!/sbin/sh

BB="busybox"
MOUNT="busybox mount"
UMOUNT="busybox umount -l"

ROMPATH=$1

if [ -d ${ROMPATH}data ]; then

	rm -rf ${ROMPATH}data/*
	rm -rf ${ROMPATH}data/.*

else

	$BB mkdir -p /tmpdata

	$MOUNT -t ext4 -o rw ${ROMPATH}data.img /tmpdata || exit 1
	$BB rm -rf /tmpdata/*
	$BB rm -rf /tmpdata/.*

	$UMOUNT /tmpdata
	rm -rf /tmpdata

	fi

exit 0
