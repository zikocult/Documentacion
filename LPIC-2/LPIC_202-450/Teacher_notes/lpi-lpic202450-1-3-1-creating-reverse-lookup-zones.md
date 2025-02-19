## Creating Reverse Lookup Zones  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the function of a reverse lookup zone. 
2. Create and enable an IPv4 and IPv6 reverse lookup zone in BIND. 
3. Create PTR records in a reverse lookup zone. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Reverse lookup zones
	+ Attempt to resolve an IP to a name
	+ Not terribly reliable
	+ One IP may have many different names
* Reverse lookup zone use cases
	+ Logging and reporting
	+ Email server validation
* Required Zone Records
	1. TTL
	2. SOA
	3. NS
* Creating a reverse lookup zone file
	+ Create a zone file
		- `sudoedit /etc/bind/222.0.10.in-addr.arpa.dns`
	+ Create core records
		- TTL
			+ Standard is 7 days
			+ `$TTL 604800`
		- Start of Authority (SOA)
		- `@ IN SOA dns1.lab.itpro.tv. admin.lab.itpro.tv. (`
			+ `1	; Serial`
			+ `86400; Refresh`
			+ `7200	; Retry`
			+ `57600; Expire`
			+ `3600); Negative Cache TTL`
		- Name Servers (NS)
			+ `@ IN NS dns1.lab.itpro.tv.`
* PTR Records
	+ Pointer records
	+ IP points to a name
	+ Example
		- `101	IN	PTR	mail1.lab.itpro.tv.`
		- `103	IN	PTR	mail2.lab.itpro.tv.`
* Activating a reverse lookup zone
	+ Add the Zone to BIND
		- `sudoedit /etc/bind/named.conf.local`
			+ Add to the bottom
			+ `zone "222.0.10.in-addr.arpa." IN { type master; file "/etc/bind/222.0.10.in-addr.arpa.dns"; };`
	+ Verify syntax
		- `named-checkzone 222.0.10.in-addr.arpa /etc/bind/222.0.10.in-addr.arpa.dns`
	+ Restart BIND
		- When adding new zones
			+ `sudo rndc reconfig`
		- When modifying a zone
			+ `sudo rndc reload 222.0.10.in-addr.arpa.`
		- Full restart
			+ `systemctl restart named.service`
* IPv6 Reverse Lookup Zones
	+ Maintained separate from IPv4
	+ Subnet defines the zone name
	+ Example
		- Subnet 2001:1234:0::/48
		- `sudoedit /etc/bind/0.0.0.0.4.3.2.1.1.0.0.2.ip6.arpa.`

#### Example IPv4 Reverse Lookup Zone

```
$TTL 604800

@ IN SOA dns1.lab.itpro.tv. admin.lab.itpro.tv. (1 1d 2h 4w 1h)

@ IN NS dns1.lab.itpro.tv.

101	IN	PTR	mail1.lab.itpro.tv.
102	IN	PTR	mail1.lab.itpro.tv.
103	IN	PTR	mail2.lab.itpro.tv.
```

#### Example IPv6 Reverse Lookup Zone

`sudoedit /etc/bind/0.0.0.0.4.3.2.1.1.0.0.2.ip6.arpa.`

```
$TTL 604800

@ IN SOA dns1.lab.itpro.tv. admin.lab.itpro.tv. (1 1d 2h 4w 1h)

@	IN	NS	dns1.lab.itpro.tv.

1.0.0.0.d.c.b.a.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.4.3.2.1.1.0.0.2.ip6.arpa.    IN    PTR    websrv01.lab.itpro.tv.
```