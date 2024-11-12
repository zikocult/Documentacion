## Configuring Port Forwarding with iptables  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe network address translation (NAT)
2. Configure *iptables* to forward a port to another host using NAT

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Configuring Port Forwarding with *iptables*
	+ Forwarding ports
	+ Performing source and destination NAT
* Configuration Steps
	1. Enable connection tracking for the port
	2. Configure Destination NAT
	3. Configure Source NAT
* Conneciton Tracking
	+ Allow connections to establish
	+ Keep a record of the connection to help identify follow-up packets
	+ `sudo iptables -A FORWARD -i enp0s6 -o enp0s5 -p tcp --syn --dport 3306 -m conntrack --ctstate NEW -j ACCEPT`
* Allow subsequent packets in the connection
	+ `iptables -A FORWARD -i enp0s6 -o enp0s5 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT`
* Network Address Translation (NAT)
	+ Destination NAT (DNAT)
		- `sudo iptables -t nat -A PREROUTING -i enp0s6 -p tcp --dport 3306 -j DNAT --to-destination 10.222.0.50`
	+ Source NAT(SNAT)
		- Individual source NAT (if global NAT is off)
		- `sudo iptables -t nat -A POSTROUTING -o enp0s5 -p tcp --dport 3306 -d 10.222.0.50 -j SNAT --to-source 10.222.0.51`
	+ Save configuration
		- `sudo iptables-save | sudo tee /etc/iptables/rules.v4`
