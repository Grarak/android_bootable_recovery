#!/sbin/sh

ROMPATH=$1
FILE=$2
MOUNTPOINT="/data/media"

updater_script_file="META-INF/com/google/android/updater-script"
update_binary_file="META-INF/com/google/android/update-binary"
rm -rf $MOUNTPOINT/rs
mkdir -p $MOUNTPOINT/rs || exit 1

unzip -qo $FILE $updater_script_file -d $MOUNTPOINT/rs || exit 1
unzip -qo $FILE $update_binary_file -d $MOUNTPOINT/rs || exit 1

cd $MOUNTPOINT/rs
cp -f $updater_script_file ${updater_script_file}_backup

sed 's|mount("ext4"|run_program("/sbin/mount_recovery.sh", "'${ROMPATH}'");#|g' -i $updater_script_file
sed 's|format("ext4"|run_program("/sbin/system_format.sh", "'${ROMPATH}'");#|g' -i $updater_script_file
sed 's|run_program("/sbin/busybox", "mount", "/system");|run_program("/sbin/mount_recovery.sh", "'${ROMPATH}'");|g' -i $updater_script_file
sed 's|run_program("/sbin/busybox", "mount", "/data");|run_program("/sbin/mount_recovery.sh", "'${ROMPATH}'");|g' -i $updater_script_file
sed 's|run_program("/sbin/busybox", "mount", "/cache");|run_program("/sbin/mount_recovery.sh", "'${ROMPATH}'");|g' -i $updater_script_file
sed s/.*\"boot.img\".*\)\;/#/ -i $updater_script_file
sed 's|run_program("/tmp/otasigcheck.sh")|#|g' -i $updater_script_file
sed -i s/.*getprop.*/#/ $updater_script_file

zip_binary $FILE $updater_script_file || exit 1
mv -f $updater_script_file ${updater_script_file}_modified
mv -f ${updater_script_file}_backup $updater_script_file

if grep -q SuperSU $update_binary_file ; then
	cp -f $update_binary_file ${update_binary_file}_backup
	sed 's|mount /system|mount_recovery.sh '${ROMPATH}'|g' -i $updater_script_file
	sed 's|mount /data|ui_print "Installing SuperSU to '${ROMPATH}'"|g' -i $updater_script_file
	zip_binary $FILE $update_binary_file || exit 1
	mv -f ${update_binary_file}_backup $update_binary_file
else
	rm -f $update_binary_file
fi

cd /

exit 0
