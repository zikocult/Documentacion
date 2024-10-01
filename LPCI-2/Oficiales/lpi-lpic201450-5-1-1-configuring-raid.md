## Configuring RAID  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Define the differences between software and hardware RAID
2. Implement Linux Software RAID 0, 1, and 5.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Linux Software RAID
	+ MD = multiple devices
	+ `/dev/md0`
* RAID
	+ Redundant Array of Independent Disks
	+ Supports (Personalities)
		- RAID 0 Stripe
		- RAID 1 Mirror
		- RAID 4 Parity disk
		- RAID 5 Parity stripe
		- RAID 6 Double Parity
		- RAID 10 Striped mirrors
* Getting started with software RAID
	+ Install mdadm
		- `sudo apt install mdadm -y`
	+ Select the disks to use
		- `lsblk`
	+ (Optional) Erase the super block
		- If previously used in a RAID array
		- `sudo mdadm --zero-superblock /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf`
* Creating a software RAID array
	+ RAID 1
		- `sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc`
	+ RAID 5
		- `sudo mdadm --create --verbose /dev/md1 --level=5 --raid-devices=3 /dev/sdd /dev/sde /dev/sdf`
* Verify creation
	- `lsblk`
	- `cat /proc/mdstat`
	- (Optional) Wait for recovery/resync to reach 100%
* Mounting a RAID disk
	+ `sudo mkfs.ext4 /dev/md0`
	+ `sudo mkfs.ext4 /dev/md1`
	+ `sudo mkdir /mnt/raid1 /mnt/raid5`
	+ `sudo mount /dev/md0 /mnt/raid1`
	+ `sudo mount /dev/md1 /mnt/raid5`
	+ `df -h`
* Make the config persistent
	+ `sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf`
	+ `sudoedit /etc/fstab`
	+ `/dev/md0 /mnt/raid1 ext4 defaults 0 0`
	+ `/dev/md1 /mnt/raid5 ext4 defaults 0 0`
* Be careful: may UDEV may renumber after first boot
	+ Consider using aliases in `/dev/md`
	+ `/dev/md/DonsLaptop:0`