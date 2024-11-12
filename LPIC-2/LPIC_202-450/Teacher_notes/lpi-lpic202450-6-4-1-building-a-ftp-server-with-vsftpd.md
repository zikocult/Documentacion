## Building a FTP Server with vsftpd  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe VSFTP and the features that it offers.
2. Install and configure a *vsftpd* FTP server on Linux.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Building a FTP Server with *vsftpd*
	+ Introduction to VSFTP
	+ Installing VSFTP
	+ Configuring Security Options
* Introduction to VSFTP (*vsftpd*)
	+ https://security.appspot.com/vsftpd.html
	+ Very Secure File Transfer Protocol Daemon (vsftpd)
	+ Written by a security researcher (Chris Evans)
	+ Ubiquitous across the web
* Installing *vsftpd*
	1. Install *vsftpd*
		+ `sudo apt install vsftpd`
	2. Enable and start the service
		+ `systemctl enable --now vsftpd`
	3. Allow traffic through the firewall
		+ `sudo ufw allow ftp`
		+ `sudo ufw allow 10000:20000/tcp`
* Configuring VSFTP
	+ Main configuration file
		- `sudoedit /etc/vsftpd.conf`
	+ Common settings
		- Restricts listening interfaces
			+ `listen_address=10.222.0.51`
		- Allow anonymous users access
			+ `anonymous_enable=YES`
		- Allow `/etc/passwd` users access
			+ `local_enable=YES`
		- Read-only mode
			+ `write_enable=YES`
			+ File system permissions still apply
			+ Does not grant write to anonymous users
		- Passive Transfer ports
			+ `pasv_enable=YES`
			+ `pasv_min_port=10000`
			+ `pasv_max_port=20000`
* User Data Access
	+ Anonymous users
		- Default directory is /srv/ftp
	+ Authenticated users
		- Default to their home folder
			+ `chroot_local_user=YES`
		- Have access to anything they would normally be able to access
* Transfer logs can be enabled
	+ Configuration
		1. Edit `/etc/vsftpd.conf`
		2. Set `xferlog_enable=YES`
		3. Restart *vsftpd*
			- `systemctl restart vsftpd.service`
	+ Log location
		- `/var/log/vsftpd.log`
* Enabling FTP/S
	+ File Transfer Protocol over SSL (FTP/S)
	+ Not very common
	+ Should use SFTP instead
	+ SFTP uses SSH to encapsulate FTP
	+ Configuration
		- `sudoedit /etc/vsftpd.conf`
		- `ssl_enable=YES`
		- Update the certificate values
