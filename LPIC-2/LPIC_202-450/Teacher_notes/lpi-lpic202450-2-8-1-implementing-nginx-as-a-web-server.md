## Implementing NginX as a Web Server  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the NginX web server and differentiate it from Apache. 
2. Install and configure a basic web server using NginX.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Implementing NginX as a Web Server
	+ Introduction to NginX
	+ Installing NginX
	+ Configuring NginX as a web server
* Introduction to NginX
	+ Pronounced "Engine X"
	+ Written multiple ways
		- nginx
		- NginX
		- NGINX
	+ High performance
	+ Simple configuration
	+ OpenSource NginX
		- https://nginx.org
	+ Commercial NginX Plus
		- https://www.nginx.com/
		- Web Application Firewall
		- Active/Active HA
		- Health Checks
	+ Static content
		- Can work with PHP, but not ideal
		- Better used as a cache for static elements
	+ Most commonly used as a load balancer or proxy
* Installing NginX
	+ Included with most distros
	+ Installing the binary
		- `sudo apt install nginx`
	+ Enabling the service
		- `sudo systemctl enable --now nginx`
		- `sudo ufw allow 80/tcp comment "NginX"`
		- `sudo systemctl enable --now nginx`
* Configuring NginX as a web server
	+ Editing the NginX configuration
		- `sudoedit /etc/nginx/sites-available/default`
	+ Change root folder
		- `root /usr/share/nginx/html;`
	+ Other common changes
		- `listen 80 default_server;`
		- `index index.html index.htm;`
		- `server_name lab.itpro.tv;`
* Testing a configuration
	+ Check the configuration for errors
		- `sudo nginx -t`
	+ Restarting NginX
		- `sudo systemctl restart nginx`
	+ Reviewing log files
		- `sudo systemctl status nginx`
		- `sudo journalctl -xe -u nginx.service`
