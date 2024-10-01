## Capacity Planning  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the metrics used to monitor system performance. 
2. Utilize general tools to evaluate system performance.
3. Describe problems that could effect key performance areas.  

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Primary performance metrics
	+ CPU
	+ Memory
	+ Disk I/O
	+ Network I/O
* *top*
	+ General purpose tool
	+ Provides a summary of real-time data
	+ Not useful for trending
	+ Shortcuts
		- **Shift-F** brings up the sort menu
		- **m** Toggles memory meter
* sar
	+ Installed with *sysstat* package
	+ Consolidates output of numerous utilities
* Components of sar (/usr/lib/systat/)
	+ *sadc* 
		- System Activity Data Collector
	+ *debian-sa1*/*sa1*/*sa2* 
		- Stores data and generates reports
	+ *sadf* 
		- Generates reports in different formats
		- CSV
		- XML
* Configuring *sar*
	+ `sudoedit /etc/default/sysstat`
		- `ENABLED="true"`
	+ `sudoedit /etc/cron.d/systat`
* *sar* logs
	+ Log rotation is configured automatically
	+ `/var/log/sysstat`
* Viewing reports
	+ `sar -u` View CPU data
	+ `sar -r` View Memory data
	+ `sar -b` View Disk I/O
	+ `sar -n` View network data
		- `sar -n IP`
		- `sar -n TCP`
		- `sar -n IP6`
* Detective Tools
	+ `uptime`
		- Has the system restarted?
	+ `ps` and `pstree`
		- What processes are running?
		- What processes are related?
	+ `w`
		- Who is logged into the system and what are they doing?
* Benchmarking Tools
	+ `ab`
		- Apache Load Generation
		- `ab -n 10000 -c 10 http://10.0.222.50/`