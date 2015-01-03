#!/sbin/sh

BB="busybox"
MOUNT="busybox mount"
UMOUNT="busybox umount -l"

$UMOUNT /data/media
$UMOUNT /data
$UMOUNT /system
$UMOUNT /cache

$UMOUNT /.firstdata

$MOUNT /data

$BB rm -rf /.firstdata

exit 0
