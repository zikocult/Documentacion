## Integrating Samba with Microsoft Active Directory  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the advantages of integrating a Linux server with the Microsoft Active Directory.
2. Join a Linux server to a MS AD domain and configure Samba to use AD authentication. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Integrating Samba with Microsoft Active Directory
	+ Joining a Linux server to an Active Directory
	+ Configuring Samba to use AD Authentication
	+ Configuring a User Map
* Why use Microsoft Active Directory?
	+ Common enterprise user directory
	+ Broad commercial support
	+ Tight MS Windows client integration
	+ Advanced features
		- Group policy objects
		- Logon scripts
		- Dynamic group management
	+ Linux integrates using SSSD
		- System Security Services Daemon
		- Allows a Linux server to join an AD domain
		- https://ubuntu.com/server/docs/service-sssd
		- Replaces the older *winbindd*
* Preparing to join a domain
	+ Add DC to hosts file
		- `sudoedit /etc/hosts`
		- `10.222.0.52 windc01 windc01.lab.itpro.tv`
	+ Install basic tools
		- `sudo apt install sssd-ad sssd-tools realmd adcli`
	+ Test connection and identify missing packages
		- `sudo realm -v discover lab.itpro.tv`
	+ Packages should already be installed
* Joining a Linux server to an Active Directory
	+ Join the domain
		- `sudo realm join -U administrator@LAB.ITPRO.TV lab.itpro.tv`
	+ Registers the Linux server as a "Member Server" in the AD
	+ Allows user authentication lookups
	+ Allows expanding group membership
* Configuring Samba to use AD Authentication
	+ Enable AD authentication in Samba
		- `sudoedit /etc/samba/smb.conf`
			+ `[global]`
			+ `security = ADS`
* Configuring a User Map
	+ Windows user names can have spaces in them
	+ Typically only an issue in Workgroups, but can affect domains as well
	+ User maps allow us to correct that
	+ Configuring a username map
		- `sudoedit /etc/samba/smb.conf`
			+ `username map = /etc/samba/username.map`
		- `sudoedit /etc/samba/username.map`
			+ `jdoe = johndoe`
			+ `dpezet = "Don Pezet"`
