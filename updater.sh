#!/bin/sh

FILENAME="$1"

unpack_fw(){
    # $1 is target OTA zip, $2 is temp dir path
    echo "Creating temporary dir and extracting firmware..."
    mkdir $2
    unzip $1 -d ./$2 1> /dev/null
    if [ $? != 0 ]
    then
        echo "unpacking failed. Cleaning..."
        rm -rf ./$2
        exit 1
    else
        echo "unpacking finished."
    fi
}

add_apps(){
    echo "Adding additional apps..."
    for i in `ls *.apk 2> /dev/null`
    do
        echo "      Copying $i"
        cp $i ./$1/system/app/$i
    done
}

rm_apps(){
    echo "Removing apps from deprecated.list"
    echo "      TODO"
}

replace_boot_anim(){
    if [ -s ./bootanimation.zip ]
    then
        echo "Replacing boot animation..."
        cp ./bootanimation.zip ./$1/system/media/bootanimation.zip
    else
        echo "Boot animation not found. Continue..."
    fi
}

pack_fw(){
    # $1 is target OTA zip, $2 is temp dir path
    echo "Creating archive with firmware..."
    # cleaning possible   
    if [ -s ./mod_$1 ]
    then
        rm ./mod_$1
    fi

    cd ./$2
    zip -q -r ../mod_$1 *
    if [ $? != 0 ]
    then
        echo "packing failed. cleaning..."
    else
        echo "packing finished. cleaning..."
    fi
    
    cd ..
    rm -rf ./$2
    echo "done"
}
###############################################################################

tempdir="temp"
target=""

if [ -f "$FILENAME" ]
then
    target=$FILENAME
    echo "Firmware was found by user - $target."
else
    for i in `ls *.zip`
    do
        unzip -l $i |grep "META-INF/com/android/otacert" > /dev/null
        # TODO find more appropriate detection method
        if [ $? == 0 ]
        then
            target=$i
        fi
    done
    if [ -f $target ]
    then
        echo "Firmware was found by script - $target"
    else
        echo "Firmware not found."
        exit 1
    fi
fi

echo "Starting modification..."
# unpacking OTA
unpack_fw $target $tempdir
# Adding all apk files from current dir to firmware
add_apps $tempdir
# Removing all unusable apks from firmware from deprecated file
rm_apps $tempdir
# Replacing boot animation 
replace_boot_anim $tempdir
# packing back to OTA zip
pack_fw $target $tempdir
