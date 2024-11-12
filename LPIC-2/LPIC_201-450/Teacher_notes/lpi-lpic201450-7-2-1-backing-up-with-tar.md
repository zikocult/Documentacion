## Backing Up with tar  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the *tar* utility and the scenarios where it is used.
2. Use *tar* to backup and restore data, including permissions and ownership settings.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* tar
	+ **T**ape **AR**chiver
	+ Designed to string multiple files together into one file
	+ Data stored serially to be written to tape
* Creating an archive
	+ `tar -cf <archive_name> <folder_name>`
	+ `tar -cf backup.tar ~/Documents`
* Compression
	+ *tar* does not compress by default
	+ `tar -czvf backup.tar.gz ~/Documents`
		- `c` Create
		- `z` Compress
		- `v` Verbose
		- `f` File name
* Restoring from a *tar* archive
	+ `tar -xzvf backup.tar.gz`
		- `x` Extract
		- `z` Decompress
		- `v` Verbose
		- `f` File name
* Maintaining permissions in an archive
	+ Must provide `-p` when creating the archive
	+ `tar -czvpf backup.tar.gz ~/Documents`
		- `c` Create
		- `z` Compress
		- `v` Verbose
		- `p` Preserve permissions
		- `f` File name
* Restoring permissions
	+ Permissions are restored automatically if they were backed up
	+ Ownership is a different story
	+ Yes, if you are root
		- `--same-owner`
		- Attempts to map the owner to an existing account
		- Otherwise assigns the current user
	+ No, if you are a normal user
		- `--no-same-owner`
		- Makes the current user the owner
