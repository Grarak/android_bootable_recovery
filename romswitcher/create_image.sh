#!/sbin/sh

BB="/sbin/busybox"

cd /

SIZE=$1
PATH=$2

if [ $SIZE == "" ] || [ $PATH == "" ]; then
	exit 1
fi

$BB dd if=/dev/zero of=${PATH} bs=1024 count=$SIZE || exit 1
/sbin/mke2fs -F -T ext4 ${PATH} || exit 1

exit 0
