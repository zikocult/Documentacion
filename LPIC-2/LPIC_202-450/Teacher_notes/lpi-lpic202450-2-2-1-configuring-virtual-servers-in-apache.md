## Configuring Virtual Servers in Apache  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the purpose and function of virtual hosts in Apache.
2. Configure virtual hosts using unique DNS names or IP addresses.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Virtual servers
	+ Web sites are a collection of web pages
	+ In Apache, a website is a virtual server
	+ Allows one Apache node to host multiple sites
	+ Called "Virtual Hosts" in the configuration
* Uniquely identifying sites
	+ DNS name
		- Typically subdomains
		- prod.lab.itpro.tv
		- dev.lab.itpro.tv
		- sales.lab.itpro.tv
	+ IP Address
		- One NIC can host many IPs
		- Apache can bond sites to IPs
	+ Port number
		- Browsers default to 80/443
		- Sites can operate on any port
		- Less ideal
			+ Requires users to type in port
			+ https://lab.itpro.tv:8080
* Defining a virtual host
	1. Create a virtual site
		- `sudoedit /etc/apache2/sites-available/lab.itpro.tv.conf`
	2. Set the required components
		- `<VirtualHost *:80>`
			+ `ServerName lab.itpro.tv`
			+ `ServerAlias www.lab.itpro.tv`
			+ `DocumentRoot "/var/www/html/lab.itpro.tv"`
		- `</VirtualHost>`
	3. Activate the site
		- `sudo a2ensite lab.itpro.tv.conf`
	4. Create the directory
		- `sudo mkdir /var/www/html/lab.itpro.tv/`
	5. Check the config
		- `apachectl configtest`
* Virtual servers with unique DNS names
	+ Continue creating virtual hosts like above
	+ Specify an alternate `ServerName` each time
* Virtual servers with unique IPs
	1. Create a virtual site
		- `sudoedit /etc/apache2/sites-available/dev.itpro.tv.conf`
	2. Set the required components
		- `<VirtualHost 10.0.222.52:80>`
			+ `ServerName dev.itpro.tv`
			+ `ServerAlias www.dev.itpro.tv`
			+ `DocumentRoot "/var/www/html/dev.itpro.tv"`
		- `</VirtualHost>`
	3. Activate the site
		- `sudo a2ensite dev.itpro.tv.conf`
	4. Create the directory
		- `sudo mkdir /var/www/html/dev.itpro.tv/`
	5. Check the config
		- `apachectl configtest`
