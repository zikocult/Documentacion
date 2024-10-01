## Measuring Memory Usage  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Identify tools used to monitor memory performance in Linux.
2. Utilize free, top, sar, and vmstat to view memory metrics. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Why monitor memory utilization
	+ Application memory leaks
	+ Excessive paging
	+ Uncommitted data changes
	+ Excessive user connections
* Getting a quick view of memory usage
	+ Current memory statistics
		- `free`
		- `free -h` (Human readable storage sizes)
		- `free -s 5` (Refresh every 5 seconds)
* *top* and *htop*
	+ Display memory usage alongside other data
	+ Press `M` to sort by memory
	+ Press `m` to change memory meter
* Historical memory usage
	+ Tools like *sar* in the *sysstat* package are better suited
	+ `sar -r` for physical memory
* Monitoring Swap with *sar*
	+ `sar -S` for swap space utilization
	+ `sar -W` for swap page in/out
* Monitoring virtual memory with *vmstat*
	+ `vmstat 5` refreshes every 5 seconds
	+ `vmstat -s` displays a summary
* Key stats
	+ Page In
		- Normally good
		- Something going into RAM
	+ Page Out
		- Good in small quantities
		- Bad in large quantities
		- Something being bumped to free up space
	+ Swap In
		- Bad in all but small quantities
		- Something moving from RAM to disk
