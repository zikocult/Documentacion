## Configuring Wireless Adapters  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Identify wireless network adapters in Linux. 
2. Configure a wireless adapter to connect to a wireless network. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Wireless Network Adapters
	+ Configured similar to wired
	+ Required connection information to connect
		- SSID
		- WPA Supplicant
	+ Once connected, the remaining configuration is the same
* Identifying your WiFi Adapter
	+ Get WiFi Adapter name and stats
		- `sudo ip addr`
		- `sudo nmcli connection show`
		- `sudo nmcli device status`
	+ Find the WiFi network
		- `sudo nmcli dev wifi list`
* Connecting to a WiFi Network
	+ Create the connection
		- `sudo nmcli con add con-name wlx0 ifname wlx0 type wifi ssid ITProTV-Guest`
	+ Setup the WPA2 Password
		- `sudo nmcli con modify wlx0 wifi-sec.key-mgmt wpa-psk`
		- `sudo nmcli con modify wlx0 wifi-sec.psk <password>`
	+ Enable the connection
		- `sudo nmcli con up wlx0`
