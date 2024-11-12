## Building a DHCP Server  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Install and configure a DHCP server on Linux
2. Create and activate a DHCP address pool. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* *dhcpd*
	+ Managed by ISC
	+ The same people who manage BIND
	+ Standards based DHCP server
	+ Installed like most other services
		1. `sudo apt-get install isc-dhcp-server`
		2. `sudo systemctl enable --now isc-dhcp-server`
	+ NOTE: May fail to start prior to being configured
	+ NOTE: May not start if `/var/lib/dhcp/dhcpd.leases` does not already exist
* Getting Started
	+ There is an example file to help us get started
		- `/usr/share/doc/isc-dhcp-server/examples/dhcpd.conf.example`
		- It contains a lot more than we really need
	+ You have to create at least one range (scope)
	+ The IP range must overlap with an interface IP
		- eth0 has 192.168.0.10
		- Range is 192.168.0.100-150
	+ If the range does not overlap, DHCP will not listen on that NIC
* Editing the Configuration
	+ `/etc/dhcp/dhcpd.conf`
	+ Delete the file and start clean
		- `sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak`
* Enabling *dhcpd*
	+ `systemctl enable --now isc-dhcp-server`
	+ `sudo ufw allow 67/udp`
	+ `sudo ufw allow bootps`
* Troubleshooting *dhcpd*
	+ Config checker
		- `dhcpd configtest`
	+ The lease database
		- `/var/lib/dhcp/dhcpd.leases`
	+ The *systemd* journal
		- `journalctl -u isc-dhcp-server`
		- `journalctl -xeu isc-dhcp-server`

**Sample Range**
```
subnet 192.168.0.0 netmask 255.255.255.0 {
	range 192.168.0.100 192.168.0.150;
}
```

**Sample Config File**
```
default-lease-time 28800; # 8 Hours
max-lease-time 86400; # 24 Hours
subnet 172.16.0.0 netmask 255.255.255.0 {
	option subnet-mask 255.255.255.0;
	option routers 172.16.0.2;
	option domain-search "lab.itpro.tv";
	option domain-name-servers 8.8.8.8, 8.8.4.4;
	range 172.16.0.100 172.16.0.150;
}
```


```
sudoedit /etc/netplan/00-installer-config
  enps0s6
    dhcp4: no
    addresses: [172.16.1.51/24]
```