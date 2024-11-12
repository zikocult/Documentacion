## Troubleshooting DNS  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe potential issues that could cause BIND to fail.
2. Utilize the ss, systemctl, rndc, and named-checkconf utilities to troubleshoot a BIND server. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Typical BIND failures
	+ Configuration error
	+ Software/networking conflict
	+ Corrupted database
* Verify configuration files
	+ `named-checkconf`
	+ Similar to `named-checkzone`
	+ No arguments needed
* Restart BIND if necessary
	+ When adding new zones
		- `sudo rndc reconfig`
	+ When modifying a zone
		- `sudo rndc reload lab.itpro.tv`
	+ Full restart
		- `systemctl restart named.service`
* BIND startup issues
	+ Verify *named* started successfully
		- `systemctl status named.service`
	+ Check the logs
		- `journalctl -u named.service`
	+ Locating a software conflict
		- `sudo ss -natp`
* Verify database integrity
	+ Write the database to disk
		- `sudo rndc dumpdb -zones`
		- `sudo rndc dumpdb -cache`
	+ View the database export
		- `less /var/cache/bind/named_dump.db`
* DNS Client Tools
	+ `dig`
	+ `nslookup`