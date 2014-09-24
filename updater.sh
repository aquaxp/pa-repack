#!/bin/sh

if [ -e $1 ]
then
    echo "Firmware was found - $1. Starting modification..."
    echo "Creating temporary dir and extracting firmware..."
    mkdir temp
    #tar -xzf $1 -C ./temp
    unzip $1 -d ./temp 1> /dev/null
else
    echo "Firmware not found, please try again: script.sh firmware.zip"
    rm -rf temp
    exit 1
fi

echo "Adding additional apps..."
for i in `ls *.apk`
do
    echo "Copying $i"
    cp $i ./temp/system/app/$i
done

if [ -e ./bootanimation.zip ]
then
    echo "Replacing boot animation to classic nexus..."
    cp ./bootanimation.zip ./temp/system/media/bootanimation.zip
else
    echo "Boot animation not found"
fi

echo "Creating archive with firmware..."
rm mod_$1 2>/dev/null
cd temp
zip -r ../mod_$1 * 1> /dev/null
cd ..
rm -rf temp
echo "Done"
