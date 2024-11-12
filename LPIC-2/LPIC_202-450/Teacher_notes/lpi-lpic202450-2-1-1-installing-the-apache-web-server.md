## Installing the Apache Web Server  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the purpose and function of the Apache web server. 
2. Install and configure the Apache web server on Ubuntu Linux. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Apache
	+ The world's most popular web server
	+ Frequently used with NginX
	+ Serves up HTML content
	+ Provides encrypted connections
	+ Supports other features through a module system
		- PHP
		- CGI Gateway
		- Authentication
* Installing Apache
	+ Package name
		- **httpd** - RHEL-based distros
		- **apache2** - Debian-based distros
	+ Installing
		- `sudo apt install apache2`
* Starting Apache
	+ `sudo systemctl enable --now apache2`
	+ `sudo ufw allow http`
* Verifying Apache
	+ Browse to `http://<servername>`
	+ `systemctl status apache2`
* Modifying the Apache configuration
	+ Global config
		- `sudoedit /etc/apache2/apache2.conf`
		- Server name
			+ `ServerName "10.0.222.51"`
	+ Site config
		- `sudoedit /etc/apache2/sites-available/000-default.conf`
		- Content location
			+ `DocumentRoot "/var/www/html"`
		- Default index files
			+ `DirectoryIndex index.html index.php`
* Checking your configuration
	+ `apachectl configtest`
