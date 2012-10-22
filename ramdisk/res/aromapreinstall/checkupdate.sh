#!/sbin/sh

mount -t yaffs2 /dev/block/mtdblock0 /system

if [ ! -e /system/build.prop ]
then
    cd /sdcard/Download
    for MIUI_VER_NEW in `ls -1 miuiaustralia_semc-*_full.zip`
    do
        MIUI_VER_NEW_FILE="/sdcard/Download/$MIUI_VER_NEW"
        MIUI_VER_NEW=$(echo $MIUI_VER_NEW | sed 's/miuiaustralia_semc-//g;s/_full\.zip//g')
        echo "update="$MIUI_VER_NEW_FILE > /cache/update.prop
        echo "version="$MIUI_VER_NEW >> /cache/update.prop
        echo "type=fresh" >> /cache/update.prop
        echo "" >> /cache/update.prop
    done
    cd /
    return 0
else
    MIUI_VER_CURRENT=$(grep -F "ro.build.version.incremental=" /system/build.prop | sed 's/ro\.build\.version\.incremental=//g')    
    cd /sdcard/Download
    MIUI_VER_NEW=$MIUI_VER_CURRENT
    for MIUI_VER_NEW in `ls -1 miuiaustralia_semc-*_update.zip`
    do
        MIUI_VER_NEW_FILE="/sdcard/Download/$MIUI_VER_NEW"
        MIUI_VER_NEW=$(echo $MIUI_VER_NEW | sed 's/miuiaustralia_semc-//g;s/_update\.zip//g')
    done
    if [ `/res/aromapreinstall/updatecomp.sh $MIUI_VER_CURRENT $MIUI_VER_NEW`==2 ] && [ -e "$MIUI_VER_NEW_FILE" ]
    then
        echo "update="$MIUI_VER_NEW_FILE > /cache/update.prop
        echo "version="$MIUI_VER_NEW >> /cache/update.prop
        echo "type=update" >> /cache/update.prop
        echo "" >> /cache/update.prop
    fi
    if [ -e "/sdcard/Download/miuiaustralia_semc-"$MIUI_VER_CURRENT"_multilang.zip" ]
    then
        if [ ! -e "/system/etc/multilang" ]
        then
            echo "update=/sdcard/Download/miuiaustralia_semc-"$MIUI_VER_CURRENT"_multilang.zip" > /cache/update.prop
            echo "version="$MIUI_VER_CURRENT >> /cache/update.prop
            echo "type=multilang" >> /cache/update.prop
            echo "" >> /cache/update.prop
        fi
    fi
fi

cd /
unset MIUI_VER_NEW
unset MIUI_VER_NEW_FILE
unset MIUI_VER_CURRENT

