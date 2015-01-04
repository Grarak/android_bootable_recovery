#!/sbin/sh

BB="busybox"
MOUNT="busybox mount"
UMOUNT="busybox umount -l"
ROMPATH=`echo $1 | sed 's|/sdcard/.romswitcher|/.firstdata/media/.romswitcher|g'`

while read par path emmc; do
	case $path in
	*system) system=$par ;;
	*data) data=$par ;;
	*cache) cache=$par ;;
	esac
done < /etc/recovery.fstab

$UMOUNT /system
$UMOUNT /cache
$UMOUNT /data/media
$UMOUNT /data
$UMOUNT /.firstdata

$BB mkdir -p /.firstdata
$MOUNT -t ext4 -o rw $data /.firstdata

$BB mkdir -p /data
$BB mkdir -p /cache
$BB mkdir -p /system

if [ -d ${ROMPATH}system ]; then

	$BB mkdir -p ${ROMPATH}data
	$BB mkdir -p ${ROMPATH}cache

	$MOUNT --bind ${ROMPATH}data /data
	$BB mkdir -p /data/media

	$MOUNT --bind /.firstdata/media /data/media

	$MOUNT --bind ${ROMPATH}cache /cache

	$MOUNT --bind ${ROMPATH}system /system

else

	$MOUNT -t ext4 ${ROMPATH}data.img /data
	$BB mkdir -p /data/media

	$MOUNT --bind /.firstdata/media /data/media

	$MOUNT -t ext4 ${ROMPATH}cache.img /cache

	$MOUNT -t ext4 ${ROMPATH}system.img /system

fi

exit 0
