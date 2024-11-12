## Backing Up with rsync  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the rsync utility and its use-case scenarios.
2. Use rsync to replicate files and folders on a Linux host.
3. Use rsync to replicate data via an SSH tunnel to another host.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* *rsync*
	+ Synchronize files between multiple systems
	+ Can perform one-time copies
	+ Can be used to setup scheduled synchronizations
	+ Operations can be one-way or bidirectional
	+ General usage
		- `rsync <options> <source> <destination>`
* Backup a folder to another location
	+ `rsync -azurP ~/Documents ~/Backup`
	+ `-a` Archive (copy attributes)
	+ `-z` Compress with gzip
	+ `-u` Skip files that are already there
	+ `-r` Recursive
	+ `-P` Display progress
* Remote backup
	+ *rsync* Listener
		- Requires rsync running on the remote host
		- TCP port 873
		- Fairly dated, not secure
		- `rsync -azurP /home/dpezet/Documents dpezet@10.0.222.50:/home/dpezet/`
	+ *rsync* over SSH
		- Encrypted tunnel
		- SSH is easy to open on firewalls
		- `rsync -azurP -e ssh /home/dpezet/Documents dpezet@10.0.222.50:/home/dpezet/`
* Include/Exclude
	+ Can specify files to handle differently
	+ Can combine include/exclude
		- Applied in order
	+ Transfer all except...
		- Exclude should come first
		- `rsync -azurP --exclude="*.pdf" --include ".*" /home/dpezet/Documents /home/dpezet/Backup`
	+ Transfer nothing except...
		- Include should come first
		- `rsync -azurP --include="*.pdf" --exclude ".*" /home/dpezet/Documents /home/dpezet/Backup`
* Perform a test run
	+ `--dry-run`
	+ Does not actually copy/delete files
* Preserving permissions 
	+ Requires root
	+ `-ogA`
		- `-o` Owner
		- `-g` Group
		- `-p` Permissions
		- `-A` ACLs (implies -p)
