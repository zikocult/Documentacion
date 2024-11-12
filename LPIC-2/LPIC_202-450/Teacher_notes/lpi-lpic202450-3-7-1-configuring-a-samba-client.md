## Configuring a Samba Client  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the methods of connecting a Linux workstation to an CIFS or SMB share on the network. 
2. Use the CLI, GUI, and fstab file to connect to a shared folder. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Configuring a Samba Client
	+ Mounting a Samba share from the CLI
	+ Mounting a Samba share from the GUI
	+ Mounting a Samba share at boot-time
* Choosing a connection method
	+ Mounting a Samba share from the CLI
		- Useful for temporary connections
		- Useful for scripting/automating connections
		- Useful for headless servers
	+ Mounting a Samba share from the GUI
		- Useful for desktop clients
		- Easy to understand for end users
	+ Mounting a Samba share at boot-time
		- Useful for frequently accessed shares
		- Useful for shared machines with multiple users
* Mounting a Samba share from the CLI
	1. Install the required tools
		- `sudo apt install cifs-utils`
	2. Create a mount point
		- `mkdir /mnt/corp`
	3. Connect to the shared folder via SMB
		- `mount -t cifs -o user=dpezet,password=<password>,noperm //localhost/corp /mnt/corp`
* Mounting a Samba share from the GUI
	1. Launch the Gnome file browser (Nautilus)
	2. Select `Other-locations` from the navigation tree
	3. Enter `smb://10.222.0.51/corp`
	4. Authenticate
* Mounting a Samba share at boot
	1. Store credentials
		+ `nano ~/.smbcredentials`
		+ `user=dpezet`
		+ `password=password123`
	2. Create your mount point
		+ `sudo mkdir /mnt/corp`
		+ `sudo chown dpezet:dpezet /mnt/corp`
	2. Get your User ID and Group ID
		+ `id`
	3. Update the file system table
		+ `sudoedit /etc/fstab`
		+ `//10.222.0.51/corp	/mnt/corp	cifs	credentials=/home/dpezet/.smbcredentials,uid=1001,gid=1001,noperm	0	0`
