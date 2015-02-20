#!/sbin/sh

ROMPATH=$1
FILE="/tmp/rs_update.zip"

updater_script_file="META-INF/com/google/android/updater-script"
update_binary_file="META-INF/com/google/android/update-binary"

mkdir -p /tmp
[ -e $2 ] || exit 1
cp -f $2 /tmp/rs_update.zip
[ -e $FILE ] || exit 1

rm -rf /tmp/rs
mkdir -p /tmp/rs || exit 1

unzip -qo $FILE $updater_script_file -d /tmp/rs || exit 1
unzip -qo $FILE $update_binary_file -d /tmp/rs || exit 1

cd /tmp/rs
sed 's|mount("ext4"|run_program("/sbin/mount_recovery.sh", "'${ROMPATH}'");#|g' -i $updater_script_file
sed 's|format("ext4"|run_program("/sbin/system_format.sh", "'${ROMPATH}'");#|g' -i $updater_script_file
sed 's|run_program("/sbin/busybox", "mount"|run_program("/sbin/mount_recovery.sh", "'${ROMPATH}'");#|g' -i $updater_script_file
sed 's|run_program("/sbin/mount"|run_program("/sbin/mount_recovery.sh", "'${ROMPATH}'");#|g' -i $updater_script_file
sed s/.*\"boot.img\".*\)\;/#/ -i $updater_script_file
sed 's|run_program("/tmp/otasigcheck.sh")|#|g' -i $updater_script_file
sed -i s/.*getprop.*/#/ $updater_script_file

zip_binary $FILE $updater_script_file || exit 1
if grep -q SuperSU $update_binary_file ; then
	sed 's|mount /system|mount_recovery.sh '${ROMPATH}'|g' -i $updater_script_file
	sed 's|mount /data|ui_print "Installing SuperSU to '${ROMPATH}'"|g' -i $updater_script_file
	zip_binary $FILE $update_binary_file || exit 1
else
	rm -f $update_binary_file
fi

cd /

exit 0
