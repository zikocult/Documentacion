## Building an SMTP Server with Postfix  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the Postfix MTA and its uses.
2. Install and configure Postfix on Linux.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* What is Postfix
	+ Message Transfer Agent (MTA)
		- Uses the Simple Mail Transport Protocol (SMTP)
	+ Moves email between mailboxes and servers
	+ Does not provide client access
		- Send, not receive
	+ Postfix is not one program
		- Made up of a number of executables and services
* Postfix history
	+ https://www.postfix.org/
	+ Originally developed by IBM
	+ Designed to replace *sendmail*
		- *sendmail* is a legacy MTA
	+ Postfix provides
		- Better performance
		- Enhanced security features
		- Actively supported
* Installing Postfix
	+ Installing the binaries only
		- `sudo apt install postfix`
	+ Installing the binaries and starting the configruation
		- `sudo DEBIAN_PRIORITY=low apt install postfix`
	+ Can be run later
		- `sudo dpkg-reconfigure postfix`
* Initial Configuration
	+ Very important to complete configuration
		- Improperly configured MTAs can become open relays
		- Responsible for a good portion of SPAM on the Internet
	+ Installation choices
		1. Determine the type of MTA you are configuring
		2. Define the default domain name
		3. Assign someone to receive admin emails
		4. List authoritative domains
		5. Enable/disable synchronous mail processing
		6. List allowed client IPs
		7. Assign maximum mailbox size
		8. (Optional) Define a local extension character
			- Creates dynamic aliases
		9. Select desired L3 protocols to support
* Postfix configuration
	+ Configuration file
		- `/etc/postfix/main.cf`
	+ Configuration utility
		- `postconf`
		- `postconf -n` to list all non-default values
		- `sudo postconf -e 'home_mailbox= Mail/'`
* Mapping users to email addresses
	1. Create an alias mapping table
		- `sudo postconf -e 'virtual_alias_maps= hash:/etc/postfix/maps'`
	2. Define the mappings
		- `sudoedit /etc/postfix/maps`
		- `don@lab.itpro.tv dpezet`
		- `support@lab.itpro.tv dpezet`
	3. Apply the mappings
		- `sudo postmap /etc/postfix/maps`
	4. Restart Postfix
		- `sudo systemctl restart postfix`
* Firewall access
	+ `sudo ufw allow Postfix`
	+ `sudo ufw allow 25/tcp`
	+ `sudo ufw allow proto tcp from 10.222.0.0/24 to any port 25`
