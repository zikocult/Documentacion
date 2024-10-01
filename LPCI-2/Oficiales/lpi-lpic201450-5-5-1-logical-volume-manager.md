## Logical Volume Manager  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the Logical Volume Manager and its functions.
2. Use the LVM to create and resize logical volumes.  

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Install LVM tools
	+ `sudo apt install lvm2`
* Create physical volumes
	+ `pvcreate /dev/sdb /dev/sdc`
* Verify creation
	+ `pvdisplay` or `pvs`
* Create a volume group
	+ `vgcreate vg1 /dev/sdb /dev/sdc`
	+ `vgdisplay` or `vgs`
* Create logical volumes
	+ `lvcreate -L <size> vg1 -n <name>`
	+ `lvcreate -L 250G vg1 -n website`
	+ `lvdisplay` or `lvs`
* Format and mount the logical volume
	+ `mkfs.ext4 /dev/vg1/website`
	+ `mount /dev/vg1/website /mnt/website`
* Verify volume added to /etc/fstab if needed at boot
	- `more /etc/fstab/dev/mapper/vg1-lv1`
	- `/root/Videos ext4 defaults 1 1`
		+ 1 - Do backup with `dump`
  		+ 1 - Do check for errors
* Add more storage to the volume group / logical volume
	+ `fdisk /dev/sdd`
		- n - create new partition
		- w - write changes
	+ `partprobe`
	+ `pvcreate /dev/sdd`
	+ `vgextend vg1 /dev/sdd`
	+ `lvresize -L +50G /dev/vg1/website`
	+ `df -h`
	+ `resize2fs /dev/vg1/website`
	+ `df -h`
	+ `lvdisplay`
* Tear it all down
	+ `umount <path>`
	+ `lvremove /dev/vg1/website`
	+ `vgremove /dev/vg1`
	+ `pvremove /dev/sdb /dev/sdc /dev/sdd`