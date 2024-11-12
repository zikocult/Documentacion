## Configuring an OpenVPN Client  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Install the OpenVPN client on a Linux system. 
2. Use OpenVPN to connect to a VPN server from the Linux command line.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Configuring an OpenVPN Client
	+ Installing OpenVPN
	+ Using a client profile
	+ Automatically connecting to a VPN
* Installing OpenVPN
	+ OpenVPN client uses the same package as server
	+ `sudo apt install openvpn`
* Loading a client configuration
	+ OpenVPN outputs a `*.ovpn` file
		- Text file with configuration commands and certificates
		- Should be renamed `*.conf` and placed in `/etc/openvpn/client`
	+ Example
		- `sudo cp ~/Dons-Laptop.ovpn /etc/openvpn/client/Dons-Laptop.conf`
* Connecting to a VPN server
	+ Default config is read from `/etc/openvpn/client.conf`
	+ Override with the `--config` option
	+ Example
		- `sudo openvpn --client --config /etc/openvpn/client/Dons-Laptop.conf`
* Testing client connectivity
	+ Test commands
		- `ip route`
		- `ip -br addr`
		- `ping 10.8.0.1`
		- `Ctrl-C` to stop
	+ Logging
		- If logging is enabled on the server
			+ `/var/log/openvpn/`
		- Otherwise
			+ `sudo journalctl -xeu openvpn@client`
* Configuring an "Always On" VPN
	+ `sudo cp /etc/openvpn/client/Dons-Laptop.conf /etc/openvpn/client.conf`
	+ `sudo systemctl start openvpn@client`
