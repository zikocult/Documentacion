## Backing Up with dd  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe scenarios where the dd utility can be used for backups.
2. Use dd to backup a disk, partition, and MBR.
3. Restore data using dd. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Introduction to *dd*
	+ Very old tool
	+ Originally designed to convert files from one format to another
	+ Now used to clone disks and partitions
	+ Built in to almost all distros
	+ Useful when a full disk image is required
		- Includes boot record and other data
* Clone a disk
	+ `sudo dd if=/dev/sda of=/dev/sdb`
* Source disks
	+ Can be online
	+ You should minimize writes during the operation
* Display status
	+ `status=progress`
* *dd* Command Line Options
	+ Ignore errors
		- `conv=noerror`
	+ Increase block size
		- 512 is default
		- `bs=64K`
		- `bs=1M`
	+ Ensure perfect copy
		- `conv=sync`
		- Very slow
		- Check all writes before progressing
* Backup a partition
	+ `dd if=/dev/sda1 of=~/part1.img`
* Backup just the MBR
	+ `dd if=/dev/sda of=~/sda0.img count=1 bs=512`
* Compressing the backup
	+ Not natively supported
	+ Pipe the backup through gzip
	+ `sudo dd if=/dev/sdd bs=1M | gzip -c  > ~/sdd.img.gz`
* Restoring a disk
	+ `dd if=./sda.img of=/dev/sdc`
	+ `gunzip -c ~/sdd.img.gz | dd of=/dev/sdd bs=1M`