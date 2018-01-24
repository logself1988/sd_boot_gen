sd_boot_gen
====
Bootable SD Card Generator for Embedded Linux System.

Guide
----
1. Please check the device of your SD card with fdisk.  

	sudo fdisk -l

2. Download the shell script and run.
	
	chmod +x sd_boot_gen.sh

	./sd_boot_gen /dev/sdx

Note
----
1. Modify the script with filename and directory as you need.  
2. Modify the uboot boot offset as you need.


