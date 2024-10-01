## Supporting Solid State Disks  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Differentiate between traditional and solid-state disks.
2. Verify TRIM and manually trigger TRIM operations.
3. Describe the differences between SSD and NVMe disks. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Solid-state Disks (SSD)
	+ Most are like SATA disks
	+ Heavy fragmentation
	+ Write amplification
	+ TRIM
* TRIM
	+ View whether TRIM is supported
		- `sudo hdparm -I /dev/sda | grep TRIM`
	+ Manually trim a disk
		- `sudo fstrim -v <mountpoint>`
* NVMe Disks
	+ Non-volatile Memory Express
	+ Namespaces
	+ No AHCI interface, so normal tools don't work
	+ Implements DSM Deallocate instead of TRIM
		- Data Set Management (DSM)
* Working with NVMe disks
	+ `sudo apt install nvme-cli`
	+ List commands
		- `nvme help`
	+ Check SMART status
		- `sudo nvme smart-log /dev/nvme0n1`