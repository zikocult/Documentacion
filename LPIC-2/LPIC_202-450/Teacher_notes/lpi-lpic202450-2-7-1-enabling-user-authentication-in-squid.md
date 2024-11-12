## Enabling User Authentication in Squid  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Configure the squid proxy server to require user authentication for access.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Enabling User Authentication in Squid
	+ Types of authentication
	+ Enabling authentication
	+ Authenticating with a client
* Types of authentication
	+ Examples
		- Samba
		- LDAP
		- HTTP basic authentication
	+ Look in `/usr/lib/squid` for a full list
* Enabling authentication
	1. Edit your configuration
		- `sudoedit /etc/squid/conf.d/local.conf`
	2. Define the protocol and user location
		- `auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/htpasswd`
		- `auth_param basic realm proxy`
	3. Restrict access to authenticated users
		- `acl internal src 10.0.0.0/255.0.0.0`
		- `acl authenticated proxy_auth REQUIRED`
		- `http_access allow internal authenticated`
		- `http_access deny all`
* Configuring user accounts
	+ Creating passwords
		- `sudo htpasswd -c /etc/squid/htpasswd dpezet`
		- Leave off `-c` to append
	+ Test authentication
		- `/usr/lib/squid/basic_ncsa_auth /etc/squid/htpasswd`
		- `dpezet password123`
	+ Restart squid
		- `sudo systemctl restart squid`
* Authenticating with a client
	+ Most web browsers support proxy authentication
	+ FireFox
		- `Menu -> Preferences -> Network Settings -> Connection Settings`
		- Or search for `Proxy` in the settings
