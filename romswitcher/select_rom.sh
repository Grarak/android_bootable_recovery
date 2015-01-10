#!/sbin/sh

BB="busybox"

if [ -d ${1}/system ]; then
	ROMPATH=`echo $1 | sed 's|/sdcard/.romswitcher||g'`
	ROMPATH=`echo $ROMPATH | sed 's|/||g'`
else
	ROMPATH=`echo $1 | sed 's|/storage/sdcard1/.romswitcher|/external_sd/.romswitcher|g'`
fi

echo $ROMPATH > /data/media/.rom

exit 0
