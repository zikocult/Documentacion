## Installing the Squid Proxy Server  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the purpose and function of a proxy server. 
2. Install and configure the squid proxy server in Linux.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Installing the Squid Proxy Server
	+ Introduction to squid
	+ Installing squid
	+ Enabling caching
	+ Verify squid is functioning
* Introduction to squid
	+ http://www.squid-cache.org/
	+ Open source proxy server
	+ Features
		- Caching
		- Filtering
		- Authentication
* Installing squid
	+ `sudo apt install squid`
	+ `sudo systemctl enable --now squid`
	+ `sudo systemctl status squid`
* Initial configuration
	+ Default configuration
		- `/etc/squid/squid.conf`
	+ Edit the configuration
		- `sudoedit /etc/squid/conf.d/local.conf`
	+ Changing the listening port
		- Defaults to 3128
		- `http_port 8080`
	+ Firewall configuration
		- `sudo ufw allow 8080 comment "Squid Proxy"`
* Enabling caching
	+ Define cache directory
		- `cache_dir <filesystem> <path> <max-size-mb> <max-folders> <max-subfolders>`
	+ Default values
		- `cache_dir ufs /var/spool/squid 100 16 256`
* Verify squid is functioning
	+ Log files
		- `sudo systemctl status squid`
		- `journalctl -xe -u squid.service`
	+ Network listeners
		- `sudo ss -natp`
	+ Connect a client (FireFox)
		- Won't work until an ACL is configured
		- `Settings -> Network Settings -> Proxy`
