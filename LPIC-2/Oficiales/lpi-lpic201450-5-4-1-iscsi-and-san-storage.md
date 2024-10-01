## iSCSI and SAN Storage  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe connectivity methods used with Storage Area Networks.
2. Configure a Linux server to act as an iSCSI target.
3. Configure a Linux client to connect to iSCSI storage.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* SAN
	+ Storage Area Network
	+ Allows external hard drives to be pooled and shared
	+ Typically attached via Fiber
* HBA
	+ Host Bus Adapter
	+ Designed for a SAN
	+ Cross between Hard drive controller and NIC
	+ Drives show up as local drives
	+ Typically little or no configuration needed
* Accessing a SAN via network
	+ iSCSI 
		- Internet SCSI
		- SCSI protocol encapsulated in TCP/IP
		- Moderate performance
		- Suitable for LAN
	+ FCoE 
		- Fiber Channel over Ethernet
		- FC protocol encapsulated in TCP/IP
		- Poor performance
		- Suitable for replicating between locations
	+ AoE 
		- ATA over Ethernet
		- ATA protocol run at Layer 2
		- Not routable
		- Good performance
* Creating an iSCSI Target (Server)
	+ `sudo apt install tgt -y`
	+ `sudo systemctl enable --now tgt`
	+ `sudoedit /etc/tgt/conf.d/tgt.conf`

```
<target iqn.dons-server:storage>
  backing-store /dev/sdc
  initiator-address 10.0.222.50
</target>
```

* Verifying the iSCSI server
	+ `sudo systemctl restart tgt`
	+ `sudo tgtadm --mode target --op show`
	+ `sudo ss -natp`
	+ `sudo ufw allow 3260/tcp comment "iSCSI Target"`
	+ Reboot may be necessary if disks are locked
* Configuring an iSCSI Client
	+ `sudo apt install open-iscsi -y`
	+ `sudo iscsiadm -m discovery -t st -p 10.0.222.51`
	+ `sudoedit /etc/iscsi/initiatorname.iscsi`
		- `InitiatorName=iqn.dons-server:storage`
* Make it start automatically
	+ `sudoedit /etc/iscsi/nodes/iqn.dons-server\:storage/10.0.222.51\,3260\,1/default`
	+ Change: 
		- `node.startup = manual`
		- `node.startup = automatic`
* Verify connection
	+ `sudo systemctl restart open-iscsi iscsid`
	+ `sudo iscsiadm -m session -o show`
	+ `sudo iscsiadm -m session -P3`
	+ `sudo iscsiadm -m session -P3 | grep scsi`
	+ `lsblk`
* Configuring Authentication - Target
	+ `sudoedit /etc/tgt/conf.d/tgt.conf`
		- `incominguser donslaptop password123`
		- `outgoinguser dpserver password123`
	+ `sudo systemctl restart tgt`
* Configuring Authentication - Client
	+ `sudoedit /etc/iscsi/nodes/iqn.dons-server\:storage/10.0.222.51\,3260\,1/default`
	+ Change: 
		- `node.session.auth.authmethod = None`
	+ To:
	
```
node.session.auth.authmethod = CHAP
node.session.auth.username = donslaptop
node.session.auth.password = password123
node.session.auth.username_in = dpserver
node.session.auth.password_in = password123
```