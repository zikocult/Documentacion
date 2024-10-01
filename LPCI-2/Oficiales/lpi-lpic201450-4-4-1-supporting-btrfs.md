## Supporting Btrfs  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the primary features of the Btrfs file system.
2. Format and mount storage with Btrfs.
3. Implement RAID, subvolumes, and snapshots with Btrfs. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Btrfs
	+ Designed by Oracle
	+ Not an acronym
		- B-Tree File System
	* Designed with features in mind, not bolt-ons
		+ Copy on Write (COW)
		+ RAID
		+ LVM
		+ Snapshots
* Formatting a disk with Btrfs
	+ `sudo apt install btrfs-progs`
	+ `sudo mkfs.btrfs /dev/sdd1`
	+ `lsblk -f`
	+ `sudo btrfs filesystem show`
* Building a RAID1 Mirror
	+ `sudo mkfs.btrfs -m raid1 -d raid1 /dev/sda /dev/sdb`
		- `-m` Metadata
		- `-d` Data
	+ The mount either one of the drives as normal
	+ Btrfs manages the mirror
* Subvolumes
	+ Designed to facilitate backups
	+ Useful for setting snapshot policies
	+ Similar to a partition
	+ A divided piece of the file system
	+ Looks like a subdirectory
	+ Mounted similar to a disk, but is a logical construct
	+ Can be mounted independently and moved about
* Creating a subvolume
	+ Mount the parent volume
		- `sudo mount /dev/sda /mnt/database`
	+ Create subvolumes
		- `sudo btrfs subvolume create /mnt/database/db`
		- `sudo btrfs subvolume create /mnt/database/tl`
	+ List subvolumes
		- `ls -la /mnt/database`
		- `sudo btrfs subvolume list -t /mnt/database`
			+ `-t` Display as table
* Snapshots
	+ Snapshots are subvolumes
	+ Contain a point-in-time replica of data
* Creating a snapshot
	+ `sudo mkdir /mnt/data/snapshots`
	+ `sudo btrfs subvolume snapshot /mnt/database/db /mnt/database/snapshots/db20210614`