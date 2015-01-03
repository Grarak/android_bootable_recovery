#!/sbin/sh

BB="busybox"
MOUNT="busybox mount"
UMOUNT="busybox umount -l"

ROMPATH=$1

if [ -d ${ROMPATH}cache ]; then

	rm -rf ${ROMPATH}cache/*
	rm -rf ${ROMPATH}cache/.*

else

	$BB mkdir -p /tmpcache

	$MOUNT -t ext4 -o rw ${ROMPATH}cache.img /tmpcache || exit 1
	$BB rm -rf /tmpcache/*
	$BB rm -rf /tmpcache/.*

	$UMOUNT /tmpcache
	rm -rf /tmpcache
fi

exit 0
