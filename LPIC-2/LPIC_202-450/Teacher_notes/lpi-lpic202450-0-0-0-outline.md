* Domain Name Server
	+ Basic DNS server configuration
		- BIND 9.x configuration files, terms and utilities
		- Defining the location of the BIND zone files in BIND configuration files
		- Reloading modified configuration and zone files
		- Awareness of dnsmasq, djbdns and PowerDNS as alternate name servers
		- Terms and Utilities:
			+ /etc/named.conf
			+ /var/named/
			+ /usr/sbin/rndc
			+ kill
			+ host
			+ dig
	+ Create and maintain DNS zones
		- BIND 9 configuration files, terms and utilities
		- Utilities to request information from the DNS server
		- Layout, content and file location of the BIND zone files
		- Various methods to add a new host in the zone files, including reverse zones
		- Terms and Utilities:
			+ /var/named/
			+ zone file syntax
			+ resource record formats
			+ named-checkzone
			+ named-compilezone
			+ masterfile-format
			+ dig
			+ nslookup
			+ host
	+ Securing a DNS server
		- BIND 9 configuration files
		- Configuring BIND to run in a chroot jail
		- Split configuration of BIND using the forwarders statement
		- Configuring and using transaction signatures (TSIG)
		- Awareness of DNSSEC and basic tools
		- Awareness of DANE and related records
		- Terms and Utilities:
			+ /etc/named.conf
			+ /etc/passwd
			+ DNSSEC
			+ dnssec-keygen
			+ dnssec-signzone
* Web Services
	+ Implementing a web server
		- Apache 2.4 configuration files, terms and utilities
		- Apache log files configuration and content
		- Access restriction methods and files
		- mod_perl and PHP configuration
		- Client user authentication files and utilities
		- Configuration of maximum requests, minimum and maximum servers and clients
		- Apache 2.4 virtual host implementation (with and without dedicated IP addresses)
		- Using redirect statements in Apache’s configuration files to customize file access
		- Terms and Utilities:
			+ access logs and error logs
			+ .htaccess
			+ httpd.conf
			+ mod_auth_basic, mod_authz_host and mod_access_compat
			+ htpasswd
			+ AuthUserFile, AuthGroupFile
			+ apachectl, apache2ctl
			+ httpd, apache2
	+ Apache configuration for HTTPS
		- SSL configuration files, tools and utilities
		- Generate a server private key and CSR for a commercial CA
		- Generate a self-signed Certificate
		- Install the key and certificate, including intermediate CAs
		- Configure Virtual Hosting using SNI
		- Awareness of the issues with Virtual Hosting and use of SSL
		- Security issues in SSL use, disable insecure protocols and ciphers
		- Terms and Utilities:
			+ Apache2 configuration files
			+ /etc/ssl/, /etc/pki/
			+ openssl, CA.pl
			+ SSLEngine, SSLCertificateKeyFile, SSLCertificateFile
			+ SSLCACertificateFile, SSLCACertificatePath
			+ SSLProtocol, SSLCipherSuite, ServerTokens, ServerSignature, TraceEnable
	+ Implementing a proxy server
		- Squid 3.x configuration files, terms and utilities
		- Access restriction methods
		- Client user authentication methods
		- Layout and content of ACL in the Squid configuration files
		- Terms and Utilities:
			+ squid.conf
			+ acl
			+ http_access
	+ Implementing Nginx as a web server and a reverse proxy
		- Nginx
		- Reverse Proxy
		- Basic Web Server
		- Terms and Utilities:
			+ /etc/nginx/
			+ nginx
* File Sharing
	+ SAMBA Server Configuration
		- Samba 4 documentation
		- Samba 4 configuration files
		- Samba 4 tools and utilities and daemons
		- Mounting CIFS shares on Linux
		- Mapping Windows user names to Linux user names
		- User-Level, Share-Level and AD security
		- Terms and Utilities:
			+ smbd, nmbd, winbindd
			+ smbcontrol, smbstatus, testparm, smbpasswd, nmblookup
			+ samba-tool
			+ net
			+ smbclient
			+ mount.cifs
			+ /etc/samba/
			+ /var/log/samba/
	+ NFS Server Configuration
		- NFS version 3 configuration files
		- NFS tools and utilities
		- Access restrictions to certain hosts and/or subnets
		- Mount options on server and client
		- TCP Wrappers
		- Awareness of NFSv4
		- Terms and Utilities:
			+ /etc/exports
			+ exportfs
			+ showmount
			+ nfsstat
			+ /proc/mounts
			+ /etc/fstab
			+ rpcinfo
			+ mountd
			+ portmapper
* Network Client Management
	+ DHCP configuration
		- DHCP configuration files, terms and utilities
		- Subnet and dynamically-allocated range setup
		- Awareness of DHCPv6 and IPv6 Router Advertisements
		- Terms and Utilities:
			+ dhcpd.conf
			+ dhcpd.leases
			+ DHCP Log messages in syslog or systemd journal
			+ arp
			+ dhcpd
			+ radvd
			+ radvd.conf
	+ PAM authentication
		- PAM configuration files, terms and utilities
		- passwd and shadow passwords
		- Use sssd for LDAP authentication
		- Terms and Utilities:
			+ /etc/pam.d/
			+ pam.conf
			+ nsswitch.conf
			+ pam_unix, pam_cracklib, pam_limits, pam_listfile, pam_sss
			+ sssd.conf
	+ LDAP client usage
		- LDAP utilities for data management and queries
		- Change user passwords
		- Querying the LDAP directory
		- Terms and Utilities:
			+ ldapsearch
			+ ldappasswd
			+ ldapadd
			+ ldapdelete
	+ Configuring an OpenLDAP server
		- OpenLDAP
		- Directory based configuration
		- Access Control
		- Distinguished Names
		- Changetype Operations
		- Schemas and Whitepages
		- Directories
		- Object IDs, Attributes and Classes
		- Terms and Utilities:
			+ slapd
			+ slapd-config
			+ LDIF
			+ slapadd
			+ slapcat
			+ slapindex
			+ /var/lib/ldap/
			+ loglevel
* E-Mail Services
	+ Using e-mail servers
		- Configuration files for postfix
		- Basic TLS configuration for postfix
		- Basic knowledge of the SMTP protocol
		- Awareness of sendmail and exim
		- Terms and Utilities:
			+ Configuration files and commands for postfix
			+ /etc/postfix/
			+ /var/spool/postfix/
			+ sendmail emulation layer commands
			+ /etc/aliases
			+ mail-related logs in /var/log/
	+ Managing E-Mail Delivery
		- Understanding of Sieve functionality, syntax and operators
		- Use Sieve to filter and sort mail with respect to sender, recipient(s), headers and size
		- Awareness of procmail
		- Terms and Utilities:
			+ Conditions and comparison operators
			+ keep, fileinto, redirect, reject, discard, stop
			+ Dovecot vacation extension
	+ Managing Remote E-Mail Delivery
		- Dovecot IMAP and POP3 configuration and administration
		- Basic TLS configuration for Dovecot
		- Awareness of Courier
		- Terms and Utilities:
			+ /etc/dovecot/
			+ dovecot.conf
			+ doveconf
			+ doveadm
* System Security
	+ Configuring a router
		- iptables and ip6tables configuration files, tools and utilities
		- Tools, commands and utilities to manage routing tables.
		- Private address ranges (IPv4) and Unique Local Addresses as well as Link Local Addresses (IPv6)
		- Port redirection and IP forwarding
		- List and write filtering and rules that accept or block IP packets based on source or destination protocol, port and address
		- Save and reload filtering configurations
		- Terms and Utilities:
			+ /proc/sys/net/ipv4/
			+ /proc/sys/net/ipv6/
			+ /etc/services
			+ iptables
			+ ip6tables
	+ Securing FTP servers
		- Configuration files, tools and utilities for Pure-FTPd and vsftpd
		- Awareness of ProFTPd
		- Understanding of passive vs. active FTP connections
		- Terms and Utilities:
			+ vsftpd.conf
			+ important Pure-FTPd command line options
	+ Secure shell (SSH)
		- OpenSSH configuration files, tools and utilities
		- Login restrictions for the superuser and the normal users
		- Managing and using server and client keys to login with and without password
		- Usage of multiple connections from multiple hosts to guard against loss of connection to remote host following configuration changes
		- Terms and Utilities:
			+ ssh
			+ sshd
			+ /etc/ssh/sshd_config
			+ /etc/ssh/
			+ Private and public key files
			+ PermitRootLogin, PubKeyAuthentication, AllowUsers, PasswordAuthentication, Protocol
	+ Security tasks
		- Tools and utilities to scan and test ports on a server
		- Locations and organizations that report security alerts as Bugtraq, CERT or other sources
		- Tools and utilities to implement an intrusion detection system (IDS)
		- Awareness of OpenVAS and Snort
		- Terms and Utilities:
			+ telnet
			+ nmap
			+ fail2ban
			+ nc
			+ iptables
	+ OpenVPN
		- OpenVPN
		- Terms and Utilities:
			+ /etc/openvpn/
			+ openvpn