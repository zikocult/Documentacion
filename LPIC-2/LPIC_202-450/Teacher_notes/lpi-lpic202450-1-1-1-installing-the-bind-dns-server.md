## Installing the BIND DNS Server  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the BIND DNS server and its purpose.
2. Install and verify BIND on a Linux server.
3. Configure access controls, caching, and forwarders in BIND.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* BIND
	+ **B**erkeley **I**nternet **N**ame **D**omain
	+ Oldest, most standards compliant DNS server
	+ Created in the 1980s
	+ *named* packaged with other tools
* BIND9
	+ Released over 20 years ago
	+ Currently supported by ISC
	+ **I**nternet **S**ystems **C**onsortium
* Installing BIND
	+ Not installed by default
	+ *systemd-resolved* provides basic services
	+ `/etc/hosts` is also commonly used
	+ Install steps
		- `sudo apt install bind9 bind9-utils`
* Utility Packages
	+ `bind9-utils`
		- Tools for managing a DNS server
		- `dnssec-*`
		- `rndc`
		- `named-checkconf`
		- `named-checkzone`
	+ `bind9-dnsutils`
		- Tools for DNS clients to query a server
		- `dig`
		- `nslookup`
		- `nsupdate`
* BIND Default Configuration
	+ Can act as a caching server
	+ Will only respond to localhost
	+ Configuration steps
		1. Define listening ports
		2. Configure access control list
		3. Configure miscellaneous options
* Listener ports
	+ TCP/UDP Port 53 by default
	+ Check for conflicts with other services
		- *dnsmasq*
		- *systemd-resolved*
	+ `sudoedit /etc/bind/named.conf.options`
		- `options {`
        	+ `listen-on port 53 { 127.0.0.1; 10.0.222.51; };`
			+ `listen-on-v6 port 53 { ::1; };`
* Access Control List
	+ Defines who can connect
	+ Defines what actions they can take
		- `acl "trusted-hosts" {`
			+ `localhost;`
			+ `localnets;`
			+ `10.0.222.51;`
			+ `10.0.0.0/16;`
		- `options {`
			+ `recursion yes;`
			+ `allow-recursion { trusted-hosts; };`
			+ `allow-query { trusted-hosts; };`
			+ `allow-transfer { none; };`
* Miscellaneous Options
	+ BIND supports many special configuration settings
	+ DNS-SEC
	+ Forwarders
		- Sends non-authoritative lookups upstream
	+ Configuration
		- `forwarders {`
			+ `8.8.8.8;`
			+ `8.8.4.4;`
* Applying changes to BIND
	+ Start *named* now, and at boot time
		- `sudo systemctl enable --now named.service`
* Allow BIND through firewall
	+ BIND needs a minimum of UDP/53
	+ `sudo ufw allow Bind9`
	+ `sudo ufw allow 53 comment "Bind DNS Server"`
