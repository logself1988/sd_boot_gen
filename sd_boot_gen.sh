#!/bin/bash

######################
## Version: V1.0    ##
## Author: Tao Yang ##
## Date: 2018.01    ##
######################

SDCARD=$1
IMAGE_DIRECTORY="."
UBOOT_FILE="u-boot.imx"
KERNEL_FILE="zImage"
DTB_FILE="imx6ul-14x14-gateway.dtb"
ROOTFS_FILE="rootfs"

echo ""
echo "WARNING!!!"
echo "AFTER THIS OPERATION, THE EXISTING CONTENT OF THE SDCARD WILL BE LOST, PLEASE CHECK AND CONFIRM!!!"
echo -n "Continue [y/N]?"
read YN

if [ "$YN" == "N" ] || [ "$YN" == "n" ] || [ "$YN" == "" ]; then
	echo "Quitting..."
	exit 1
fi

umount ${SDCARD}*

dd if=${IMAGE_DIRECTORY}/${UBOOT_FILE} of=${SDCARD} bs=512 seek=2 conv=fsync 

SIZE=`fdisk -l $SDCARD | grep Disk | awk '{print $5}'`
#CYLINDERS=`echo $SIZE/255/63/512 | bc`

echo DISK SIZE -- $SIZE Bytes
#echo CYLINDERS -- $CYLINDERS

sfdisk --Linux --unit S ${SDCARD} << EOF
20480,225279,L,*
230000,,,-
EOF

mkfs.vfat -F 32 -n "boot" ${SDCARD}1
umount ${SDCARD}1
mkdir -p /mnt/boot
mount ${SDCARD}1 /mnt/boot
cp ${IMAGE_DIRECTORY}/${KERNEL_FILE} ${IMAGE_DIRECTORY}/${DTB_FILE} /mnt/boot

mkfs.ext4 -L "rootfs" ${SDCARD}2
umount ${SDCARD}2
mkdir -p /mnt/rootfs
mount ${SDCARD}2 /mnt/rootfs
cp -r ${IMAGE_DIRECTORY}/${ROOTFS_FILE}/* /mnt/rootfs

umount ${SDCARD}*

echo Flash Done!!!
