#!/sbin/sh

BB="busybox"
MOUNT="busybox mount"
UMOUNT="busybox umount -l"

MOUNTPOINT="/data/media"
FILE=$1

updater_script_file="META-INF/com/google/android/updater-script"
update_binary_file="META-INF/com/google/android/update-binary"

cd $MOUNTPOINT/rs || exit 1
zip_binary $FILE $updater_script_file || exit 1
if [ -f $update_binary_file ]; then
	zip_binary $FILE $update_binary_file || exit 1
fi

cd /
