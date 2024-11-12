## Supporting IDE and SATA Disks  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Identify SATA and IDE disks in Linux.
2. Modify disk parameters to suit a particular workload.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* IDE and SATA Maintenance Tasks
	+ Ensure disk detection and function
	+ Modify performance settings
	+ Check for pre-failure errors
* Identifying Disks
	+ `lsblk`
	+ `sudo lshw -class disk`
		- *lshw* - **L**i**s**t **H**ard**w**are
		- IDE and SATA both show up as ATA Disks
* Disk Paramters
	+ Allow tweaking the disk to fit a specific workload
	+ Examine disk parameters
		- `sudo apt install hdparm`
		- `sudo hdparm -I /dev/sda`
		- `-I` Information
* Example: Enable/Disable Write Cache
	+ Write cache is not desirable with many databases
	+ Configuring write cache
		- Check if write cache is supported
			+ `sudo hdparm -W /dev/sda`
		- Enable
			+ `sudo hdparm -W 1 /dev/sda`
		- Disable
			+ `sudo hdparm -W 0 /dev/sda`
* SMART
	+ **S**elf-**M**onitoring **A**nalysis and **R**eporting **T**echnology
	+ Checking SMART 
		- `sudo apt install smartmontools`
		- `sudo smartctl -i /dev/sda`
	+ Query current health status
		- `sudo smartctl -H /dev/sda`
* Execute a SMART test
	+ `sudo smartctl -t <test> /dev/sda`
	+ Tests
		- short (1-2 minutes)
		- long (10+ minutes)
* View SMART results
	+ `sudo smartctl -a /dev/sda`
	+ Log results are at the bottom
