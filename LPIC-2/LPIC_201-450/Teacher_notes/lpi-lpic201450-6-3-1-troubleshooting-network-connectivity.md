## Troubleshooting Network Connectivity  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Determine the location of a network failure from the Linux CLI. 
2. Utilize ss, tcpdump, and nc to perform advanced network troubleshooting.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Establish Scope
    + IPv4
        - `ping`
        - `traceroute`
            + `yum install traceroute`
        - `tracepath`
    + IPv6
        - `ping6`
        - `traceroute6`
            + `yum install traceroute`
        - `tracepath6`
* Verifying Settings
	+ `ip`
		- Replacement for `ifconfig`
		- `ip addr`
			+ Lists interface addresses
			+ Netmasks and CIDR
		- `ip link`
			+ Displays current link status
			+ `ip -s link` provides statistics
		- `ip route`
			+ Displays the routing table
* Reset Networking
	+ `service network restart`
	+ `systemctl restart network.service`
* Viewing Network Traffic
    + ss - Display network connections
        - `ss -atp` (All sessions)
        - `ss -tp` (Active sessions)
        - `ss --route` displays routing table
        - `ss --program` attempts to display software using ports
    + Packet Capture
        - `tcpdump`
        - Displays packets passing through an interface
        - `tcpdump -i eth0 > data.txt`
        - `tail -f ./data.txt`
* Simulating a connection
    + netcat
        - `nc`
        - Tests connections to hosts
        - `nc itpro.tv 80`
        - `GET`
        - `netstat -an | grep itpro.tv`
