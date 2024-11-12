## Building a File Server with Samba  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the purpose and function of Samba 4. 
2. Configure a Linux host as a Samba server. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Building a File Server with Samba
	+ What is Samba?
	+ Installing Samba Server
	+ Allowing Samba through a Firewall
	+ Samba Server Configuration
* What is Samba?
	+ https://www.samba.org/
	+ SMB Protocol
		- Server Message Block
		- Developed by IBM
		- Built on by Microsoft for Windows for Workgroups
	+ CIFS
		- Common Internet File System
		- Technical specification for open use of SMB
* Installing Samba Server
	+ `sudo apt install samba`
	+ Other packages
		- VFS: Virtual File System
			+ Default FS is the Linux file system
			+ Expanded filesystem modules are used mostly for NAS devices
		- AD-DC: Active Directory Domain Controller
			+ Windows Domain Controller emulation
		- DSDB: Directory Services Database
			+ LDAP variant (LDB) developed for Samba
* Allowing Samba through a Firewall
	+ SMB Network Ports
		- UDP/137: NetBIOS Name Service
		- UDP/138: NetBIOS Datagram Service
		- TCP/139: SMB over NetBIOS (Pre-Windows 2000)
		- TCP/445: SMB over TCP (Windows 2000 and newer)
	+ Allowing access
		- `sudo ufw allow Samba`
		- `sudo ufw allow from 10.222.0.0/24 to any app Samba`
* Samba Server Configuration
	+ Configuration File
		- /etc/samba/smb.conf
	+ Common initial changes
		- Workgroup name
		- Listening interfaces
	+ Check for errors
		- `testparm`
	+ Starting Samba
		- `sudo systemctl enable --now smbd`
* Common Installation Issues
	+ Samba won't start without a proper hostname
		- `hostnamectl set-hostname <name>`
		- Or define it in `/etc/samba/smb.conf`
