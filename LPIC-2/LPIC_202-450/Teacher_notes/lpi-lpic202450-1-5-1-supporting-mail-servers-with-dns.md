## Supporting Mail Servers with DNS  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe how MX, SPF, and SRV records are used by email servers. 
2. Configure MX, SPF, and SRV records in a Bind forward lookup zone.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Supporting Mail Servers with DNS
	+ Email servers have special requirements
	+ Record types
		- **MX** - Mail Exchanger
		- **SPF** - Sender Policy Framework
		- **SRV** - Service Locator
	+ Stored alongside other zone records
	+ `sudoedit /etc/bind/lab.itpro.tv.dns`
* Mail Exchanger (MX) Records
	+ Used to locate an SMTP server
	+ Required for proper email operation
	+ Example: user@lab.itpro.tv
		- A lookup is performed against the lab.itpro.tv domain
		- The MX records identify the email servers
	+ Format
		- `@ 3600 IN MX 10 mail.lab.itpro.tv.`
		- `<Host> <TTL> <Class> <Type> <Priority> <Server>`
* Sender Policy Framework (SPF) Records
	+ Used to identify servers authorized to send email for a domain
	+ Not required
	+ Affects your deliverability (spam rating)
	+ Format
		- Not an actual record type
		- Embedded in a TXT record
		- `@ 3600 IN TXT "v=spf1 mx -all"`
		- `<Host> <TTL> <Class> <Type> <SPF values>`
	+ SPF values
		- `v` - Version
		- `mx` - Allow servers with MX records to send
		- `-all` - Strict
		- `?all` - Neutral
		- `~all` - Soft fail
* Specifying outbound servers
	+ Syntax
		- `mx` - Use addresses from MX records
		- `a` - Use an address from a specific A record
		- `ip4` - Use a specific IPv4 address or CIDR range
		- `ip6` - Use a specific IPv6 address or range
		- `include` - Use records from an external domain
	+ Example
		- `v=spf1 mx a:smtp.lab.itpro.tv ip4:10.0.222.51 10.0.0.0/24 ip6:2001:1234::4321:2 include:mail.office365.com mail.sendgrid.com ~all`
* Service Locator (SRV) Records
	+ Versatile record
	+ Allows locating just about any service
	+ Provides more data than a normal record
		- Protocol - TLS, LDAP, SSH, etc.
		- Priority - Defined preferred server. Lower number wins.
		- Weight - Tie breaker for Priority. Higher number wins.
		- Port number - TCP/UDP port assigned to the service
	+ Example: VoIP support for Office 365
		- `_sip._tls 3600 IN SRV 100 1 443 mail.lab.itpro.tv.`
		- `<Service/Protocol> <TTL> <Class> <Type> <Priority> <Weight> <Port> <Host>`
