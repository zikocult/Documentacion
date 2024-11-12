## Configuring Physical Adapters  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. View the currently used network configuration. 
2. Modify the configuration of a network adapter under Red Hat and Debian based operating systems. 
3. Use the Network Manager to modify a system's network configuration. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Viewing Configuration
	+ `ifconfig`
	+ `ip addr`
	+ `ip route`
* DHCP
    + DHCP Release
	    - `dhclient -r`
    + DHCP Renew
	    - `dhclient`
* Restarting the network service
	+ Most changes require restarting the network service
	+ `service network restart`
	+ `systemctl restart network-manager`
* Configuration using interface scripts
    + RHEL/CentOS
	    - Stored in `/etc/sysconfig/network-scripts`
    	- `/etc/sysconfig/network-scripts/ifcfg-eno1`
        - Or overridden by NetworkManager
    + Debian/Ubuntu
        - Stored in `/etc/network/interfaces`
        - Or overridden by NetPlan
* Network Interface Naming Convention
	+ First part of name
		- `en` = Ethernet
		- `wl` = Wireless
		- `ww` = Cellular (WWAN)
	+ Second part of name
		- `o` = On-board
		- `p` = PCI card
		- `s` = Hotplug slot
* Configuration using global settings
	+ Name Lookups
		- `/etc/resolv.conf`
			+ DNS Servers
			+ May be managed by NetworkManager or systemd-resolvd
		- `/etc/hosts`
			+ Overrides DNS
    + Network Manager
		- NM copies DNS settings from the interface config or DHCP
    + systemd-resolvd
        - Viewing Settings
            + `resolvectl status`
            + `cat /etc/systemd/resolved.conf`
        - Changing settings
            + `sudoedit /etc/resolvconf/resolv.conf.d/head`
            + `nameserver 4.2.2.1`
            + `sudo systemctl restart systemd-resolved`
* Host Name
    + `/etc/hostname`
        - `hostname <name>` is not normally persistent
        - Defines a machines hostname
        - To modify:
            + `hostnamectl set-hostname <name>`
        - To verify:
            + `hostnamectl status`
* Configuring using NetworkManager
	+ Viewing Status
		- `nmcli device status`
		- `nmcli device show <int_name>`
		- `nmcli connection show`
		- `nmcli connection show <int_name>`
	+ Reseting an Adapter
		- `nmcli connection reload`
		- `nmcli connection down <int_name>`
		- `nmcli connection up <int_name>`
	+ Configuring an Adapter
		- `nmcli connection edit <int_name>`
		- `set connection.autoconnect yes`
		- `set ipv4.method manual`
		- `set ipv4.addr 192.168.0.2/24`
		- `set ipv4.dns 8.8.8.8`
		- `set ipv4.gateway 192.168.0.1`
		- `save <temporary/persistent>`
		- `quit`

---
---

## RHEL Configuration File

```
DEVICE=eno1
TYPE=Ethernet
BOOTPROTO=none
IPADDR0=192.168.0.2
PREFIX0=24
GATEWAY0=192.168.0.1
ONBOOT=yes
```

## Debian Configuration File

```
auto eno1
iface eno1 inet static
  address 192.168.0.2
  netmask 255.255.255.0
  gateway 192.168.0.1
```