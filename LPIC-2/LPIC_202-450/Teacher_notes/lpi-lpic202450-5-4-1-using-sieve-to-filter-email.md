## Using Sieve to Filter Email  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the Sieve filtering language and its uses. 
2. Configure Dovecot to apply Sieve filter rules to incoming email.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Using Sieve to Filter Email
	+ Introduction to Sieve
	+ Configuring Sieve with Dovecot
	+ Creating Sieve Rules
* Introduction to Sieve
	+ http://sieve.info/
	+ Email filter scripting language
	+ Used by most web-mail and anti-spam systems
		- Spam Assassin
		- ClamAV
		- Dovecot
		- Roundcube
	+ Has a unique syntax
	+ https://www.rfc-editor.org/rfc/rfc5228.html

#### Configuring Sieve with Dovecot

**1. Install Required Packages**

`sudo apt install dovecot-sieve dovecot-managesieved dovecot-lmtpd`

**2. Enable the Local Mail Transfer Protocol (LMTP)**

`sudoedit /etc/dovecot/conf.d/10-master.conf`

```
service lmtp {
	unix_listener /var/spool/postfix/private/dovecot-lmtp {
		mode = 0600
		user = postfix
		group = postfix
	}
}
```

`sudoedit /etc/postfix/main.cf`

```
mailbox_transport = lmtp:unix:private/dovecot-lmtp
smtputf8_enable = no
```

**3. Enable Sieve**

`sudoedit /etc/dovecot/conf.d/20-lmtp.conf`

```
postmaster_address = admin@lab.itpro.tv
mail_plugins = $mail_plugins sieve
```

`sudoedit /etc/dovecot/conf.d/20-imap.conf`

```
mail_plugins = $mail_plugins imap_sieve
```

`sudoedit /etc/dovecot/conf.d/90-sieve.conf`

```
plugin {
	sieve = ~/.dovecot.sieve
	sieve_global_path = /var/lib/dovecot/sieve/default.sieve
	sieve_dir = ~/sieve
	sieve_global_dir = /var/lib/dovecot/sieve/
}
```

**4. Restart and Test**

`systemctl restart postfix dovecot`
`telnet 127.0.0.1 4190`

**Creating Sieve Rules**

1. create a folder for global rules
	- `sudo mkdir /var/lib/dovecot/sieve`
	- `sudo touch /var/lib/dovecot/sieve/default.sieve`
	- `sudo chown -R dovecot:dovecot /var/lib/dovecot/sieve`
2. Define Rules
	- `sudoedit /var/lib/dovecot/sieve/default.sieve`
3. Compile Rules
	- `sudo sievec /var/lib/dovecot/sieve/default.sieve`

**Example Sieve Filter Rules**
```
require "fileinto";
if address "From" "bob@aol.com"
{
    fileinto "Junk";
}
if address :contains "From" "@aol.com"
{
    fileinto "Junk";
}
if header :contains "X-Spam-Flag" "YES"
{
	fileinto "Junk";
}
```