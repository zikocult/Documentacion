## Building a FTP Server with Pure-FTPd  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe Pure-FTPd and the features that it offers.
2. Install and configure a Pure-FTPd FTP server on Linux.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Building a FTP Server with Pure-FTPd
	+ Introduction to Pure-FTPd
	+ Installing and configuring Pure-FTPd
	+ Enabling security features
* Introduction to Pure-FTPd
	+ https://www.pureftpd.org/
	+ Designed with a "security first" methodology
	+ Can run entirely in user-space
	+ Built-in chroot support
	+ Offers more options than most FTP servers
* Installation Steps
	1. Install Pure-FTPd
		+ `sudo apt install pure-ftpd`
	2. Enable and start the service
		+ `systemctl enable --now pure-ftpd`
		+ Will require admin credentials the first time
	3. Allow traffic through the firewall
		+ `sudo ufw allow ftp`
		+ `sudo ufw allow 10000:20000/tcp`
* Pure-FTPd configuration
	+ Main configuration file
		- `sudoedit /etc/pure-ftpd/pure-ftpd.conf`
	+ Portable configuration
		- Create a file with the option name andthe value as the contents
		- Example: Disable anonymous users
			+ `echo yes | sudo tee /etc/pure-ftpd/conf/NoAnonymous`
	+ Common settings
		- Restricts listening interfaces
			+ `Bind 10.222.0.51`
		- Allow anonymous users access
			+ `NoAnonymous no`
		+ Passive Transfer ports
			+ `PassivePortRange 10000 20000`
			+ `echo 10000 20000 | sudo tee /etc/pure-ftpd/conf/PassivePortRange`
* Folder visibility
	+ Anonymous user acces
		- Disabled by default
		- If desired
			+ Create a user named "ftp"
			+ `/home/ftp` will be their default folder
	+ Authenticated users
		- Default to their home folder
			+ `ChrootEveryone yes`
		- Have access to anything they would normally be able to access
* Transfer logs can be enabled
	+ Configuration
		- `AltLog clf:/var/log/pure-ftpd/transfer.log`
	+ Alternate formats
		- `w3c:` W3C standard log format
		- `stats:` Optimized for statistical reporting
	+ Default Log location
		- `/var/log/pure-ftpd/transfer.log`
* Enabling FTP/S
	+ File Transfer Protocol over SSL (FTP/S)
	+ Not very common
	+ Should use SFTP instead
	+ SFTP uses SSH to encapsulate FTP
	+ Configuration
		- Enable TLS
			+ Optional: `TLS 1`
			+ Required: `TLS 2`
			+ `echo 1 | sudo tee /etc/pure-ftpd/conf/TLS`
		- Configure the certificate
			1. `openssl req -x509 -nodes -newkey rsa:2048 -keyout pure-ftpd.pem -out pure-ftpd.pem -days 365`
			2. `sudo cp pure-ftpd.pem /etc/ssl/private`
			3. `sudo chmod 600 /etc/ssl/private/pure-ftpd.pem`
			4. `sudo systemctl restart pure-ftpd`
