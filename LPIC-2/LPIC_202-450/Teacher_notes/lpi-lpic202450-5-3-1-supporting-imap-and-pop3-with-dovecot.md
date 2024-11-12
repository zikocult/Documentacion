## Supporting IMAP and POP3 with Dovecot  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the Dovecot IMAP and POP3 server and its intended uses. 
2. Install and configure Dovecot on a Linux email server. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Supporting IMAP and POP3 with Dovecot
	+ Introduction to Dovecot
	+ Installing Dovecot
	+ Configuring Dovecot for User Access
* Introduction to Dovecot
	+ https://www.dovecot.org/
	+ Popular opensource POP3 and IMAP4 server
		- Post Office Protocol
		- Internet Mail Access Protocol
	+ POP3
		- Basic email client service
		- No folder support
		- Email not intended to stay on server long term
	+ IMAP4
		- Advanced email client service
		- Folder support
		- Read/unread status synchronization between client and server
* Installing Dovecot
	+ `sudo apt install dovecot-pop3d dovecot-imapd`
	+ `sudo systemctl enable --now dovecot`
* Configuring Dovecot for User Access
	1. `sudoedit /etc/dovecot/conf.d/10-auth.conf`
		+ `disable_plaintext_auth = no`
		+ `auth_mechanisms = plain login`
	2. `sudoedit /etc/dovecot/conf.d/10-mail.conf`
		+ `mail_location = maildir:~/Mail`
	3. `sudoedit /etc/dovecot/conf.d/10-master.conf`
		+ `unix_listener /var/spool/postfix/private/auth {`
		+ `	mode = 0666`
		+ `	user = postfix`
		+ `	group = postfix`
		+ `}`
* Enabling TLS support in Dovecot
	+ `sudoedit /etc/dovecot/conf.d/10-ssl.conf`
		- `ssl = yes`
		- `ssl_cert = </etc/dovecot/private/dovecot.pem`
		- `ssl_key = </etc/dovecot/private/dovecot.key`
	+ Alternate ports
		- 110 POP3 Unencrypted
		- 995 POP3/S
		- 143 IMAP4 Unencrypted
		- 993 IMAP/S
	+ Firewall access
		- `sudo ufw allow "Dovecot POP3"`
		- `sudo ufw allow "Dovecot IMAP"`
		- `sudo ufw allow "Dovecot Secure IMAP"`
		- `sudo ufw allow "Dovecot Secure POP3"`
* Testing Dovecot
	+ `telnet 127.0.0.1 110`
		- `user dpezet`
		- `pass password123`
		- `list`
		- `retr 1`
		- `quit`
	+ `telnet 127.0.0.1 143`
	+ Configure a client like Thunderbird
