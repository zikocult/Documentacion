## Configuring a NFS Client  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Install the NFS client tools in Linux.
2. Connect to an NFS share from the Linux command line. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Installation steps
	1. Install NFS (if necessary)
		+ `sudo apt install nfs-common`
	2. Enable and Start *rpcbind* (Optional)
		+ `sudo systemctl enable --now rpcbind`
* Testing the NFS client
	+ Usually works out of the box
	+ May be blocked by firewall
	+ `showmount -e 10.0.222.51`
* Temporarily mounting an NFS share
	+ `sudo mkdir /mnt/files /mnt/reports`
	+ `sudo mount -t nfs 10.0.222.51:/srv/nfs/files /mnt/files`
	+ `sudo mount -t nfs 10.0.222.51:/srv/nfs/reports /mnt/reports`
* Permanently mounting an NFS share
	+ Add to *fstab* to mount during boot
	+ `sudoedit /etc/fstab`
	+ `<server_ip>:/share /mnt/share nfs defaults,rw,sync 0 0`
	+ `10.0.222.51:/srv/nfs/files /mnt/files nfs defaults,rw,sync 0 0`
* Testing NFS mounts
	+ Treat it like a normal file system
		- `mount`
		- `df -h`
		- `touch /mnt/share/file.txt`