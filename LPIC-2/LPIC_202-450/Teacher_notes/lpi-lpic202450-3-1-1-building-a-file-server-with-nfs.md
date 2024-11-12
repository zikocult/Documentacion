## Building a File Server with NFS  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Install and identify the primary components of NFS
2. Share folders over the network using NFS

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Network File System (NFS)
	+ Network File System
	+ Allow sharing files over the network
	+ Developed as a standard protocol
	+ Used by UNIX, Linux and macOS
		- Can be added to Windows
* Installation Steps
	1. Install NFS (if necessary)
		+ `sudo apt install nfs-kernel-server`
	2. Enable and Start Services
		+ `sudo systemctl enable --now rpcbind nfs-kernel-server`
* `rpcbind`
	+ Remote Procedure Call
	+ Connects ports between client and server
	+ NFSv2 and NFSv3 require rpcbind
	+ NFSv4 does not need it
		- Reduces the number of required ports
		- Hurts compatibility
* Sharing folders with NFS
	1. Create a folder to share
		+ `sudo mkdir -p /srv/nfs/files /srv/nfs/reports`
		+ `sudo chmod o+rw /srv/nfs/files`
		+ `sudo chmod o+r /srv/nfs/reports`
	2. Add the folder to the export list
		+ `sudoedit /etc/exports`
		+ `/srv/nfs/files	*(sync,no_subtree_check)`
		+ `/srv/nfs/reports	*(sync,no_subtree_check)`
	3. Reload the config file
		+ `sudo exportfs -r`
		+ `sudo exportfs -v` to verify
	4. Update portmap
		+ `sudo systemctl restart nfs-kernel-server`
* NFS options
	+ Generally tweak filesystem performance
	+ **sync**
		- Require writes to be complete before accepting next command
	+ **subtree_check**
		- Check to see if file is accessible in the export and the underlying filesystem
* Open firewall ports for NFS
	+ `sudo ufw allow nfs`
	+ `sudo ufw allow from 10.0.222.0/24 to any port nfs`