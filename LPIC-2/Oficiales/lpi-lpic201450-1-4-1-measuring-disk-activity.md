## Measuring Disk Activity  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the metrics used to measure disk activity.
2. Use iostat, iotop, and lsof to monitor disk activity.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* At a glance disk I/O
	+ `iotop`
	+ Lists total disk reads, writes, and swap
	+ Listed by process
	+ `iotop -a` will show accumulated data
* Examining a process
	+ We must determine the files it is reading/writing to
	+ `lsof -p <PID>`
	+ `lsof -c <process_name>` 
* Per-disk I/O stats
	+ `iostat` Lists basic disk stats
* Monitoring the disk queue length
	+ `iostat -x` lists detailed stats
	+ `iostat -xt 1` updates every 1 second
	+ `avgqu-sz` is the average queue size
* Viewing historical data
	+ `sar -b`
	+ Can be run continuosly
		- `sar -b 1`
	+ Can be filtered to a time
		- `sar -b -f /var/log/sysstat/sa18 -s 00:00:00 -e 08:00:00`
* Metrics
	+ rtps - Read requests per second
	+ wtps - Write requests per second
	+ bread/s - Blocks read per second
	+ bwrtn/s - Blocks written per second

