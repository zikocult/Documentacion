## Configuring Multiple Subnets in DHCP  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the process of DHCP pool selection.
2. Create multiple DHCP subnets and static IP address mappings in Linux.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Hosting Multiple Subnets
	+ DHCP uses broadcasts
	+ Clients only identify themselves with their MAC
	+ DHCP determines their subnet
* Assigning Client Addresses
	+ Each address pool defines a subnet
	+ When *dhcpd* starts, it matches the subnets to network interfaces
	+ Requests received on an interface get an address from the matching pool
	+ The server must have an interface in each subnet it serves
* Defining Multiple Subnets
	+ Use the `subnet` operator in the configuration
	+ Cannot overlap
* Troubleshooting *dhcpd*
	+ The lease database
		- `/var/lib/dhcp/dhcpd.leases`
	+ The *systemd* journal
		- `journalctl -u isc-dhcp-server`
		- `journalctl -xeu isc-dhcp-server`
* Static IP Mappings
	+ Also called "DHCP reservations"
	+ Ensure a client always receives the same IP
	+ Maps a MAC address to an IP address
	+ Defined as a separate range
	+ Requirements:
		- Host name
		- Host MAC Address
		- Desired IP Address
	+ NOTE: Host names are not used, but must be unique or dhcpd fails to start

**Example Satic IP**

```
host dons-laptop {
	hardware ethernet 12:34:56:AB:CD:EF;
	fixed-address 172.16.0.222;
}
```

**Example Configuration**

```
default-lease-time 28800;
max-lease-time 86400;
subnet 172.16.1.0 netmask 255.255.255.0 {
	option subnet-mask 255.255.255.0;
	range 172.16.1.100 172.16.1.200;
}
subnet 10.222.0.0 netmask 255.255.255.0 {
	option subnet-mask 255.255.255.0;
	option routers 10.222.0.1;
	option domain-search "lab.itpro.tv";
	option domain-name-servers 8.8.8.8, 8.8.4.4;
	range 10.222.0.100 10.222.0.200;
}
```