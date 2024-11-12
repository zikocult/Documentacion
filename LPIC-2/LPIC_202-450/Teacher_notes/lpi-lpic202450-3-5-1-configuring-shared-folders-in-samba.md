## Configuring Shared Folders in Samba  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the types of shared resources available in Samba.
2. Configure shared folders, printers, and home directories.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Configuring Shared Folders in Samba
	+ Types of Samba Shares
	+ Sharing Home Directories
	+ Sharing Printers
	+ Sharing Data Folders
* Types of Samba Shares
	+ Folders
	+ Printers
	+ Host Lists (Master Browser)
* Sharing Home Directories
	+ Samba can provide access to user home directories
	+ Each user has access to their own private folder
	+ Integrates well with local Linux user accounts
	+ `sudoedit /etc/samba/smb.conf`
	+ `[homes]`
		- `browseable = no`
			+ Home directories are hidden by default
		- `read only = no`
			+ Users are allowed to write to their own folder
		- `valid users = %S`
			+ `%S` allows all users
			+ `<domain>\%S` restricts the domain name
			+ `smbclient -U dpezet //localhost/dpezet`
* Sharing Printers
	+ `[printers]`
		- `path = /var/spool/samba`
			+ Defines spool folder
		- `browseable = no`
			+ Printers are hidden by default
		- `guest ok = no`
			+ Disables anonymous access
		- `writable = no`
			+ Disables ability to print
			+ Useful for maintenance
		- `printable = yes`
			+ Enables sharing all CUPS printers in Samba
* Sharing Data Folders
	1. Create a folder to share
		+ `mkdir /srv/samba/corp`
	2. Create a group to allow access
		+ `groupadd corp`
	3. Create users and add to the group
		+ `useradd dpezet`
		+ `usermod -a -G corp dpezet`
		+ `smbpasswd -a dpezet`
	4. Assign permissions to the folder
		+ `chmod 770 /srv/samba/corp`
		+ `chown dpezet:corp /srv/samba/corp`
	5. Add the folder to Samba's config file
	 	+ `sudoedit /etc/samba/smb.conf`
			- `[corp]`
			- `comment = Corporate Documents` (Optional)
			- `path = /srv/samba/corp`
			- `read only = no`
			- `browseable = yes` (Default)
			- `valid users = dpezet, +corp`
	6. Restart Samba
		+ `systemctl restart smbd.service`
* Testing Samba Shares
	+ Test Status
		- `sudo apt install smbclient`
		- `smbclient -L localhost`
	+ Starting/Stopping NetBIOS Name Server (nmbd)
		- Allows host to act as a Master Browser
		- Not needed if there are Windows servers on the network
		- `systemctl <enable/start/status> nmbd.service`
