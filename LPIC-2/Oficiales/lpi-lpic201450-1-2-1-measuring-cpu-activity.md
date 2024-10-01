## Measuring CPU Activity  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Identify tools used to monitor CPU performance in Linux.
2. Utilize ps, pstree, pmap, and mpstat to view CPU metrics. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* *top* and *htop*
	+ Displays real-time data
	+ *htop* is prettier, but brings more dependencies
	+ **Shift-F** for sort options
* Filtering *top*
	+ `top -Hp <pid>`
	+ `-H` - Display individual threads
	+ `-p` - Monitor only specified PID
* Frozen processes
	+ Typically at 0 or less CPU utilization
		- Typically still consuming RAM
	+ Easier to find them with *ps*
	+ List processes for one user
		- `ps --user <id>`
	+ List processes sorted by memory consumption
		- `ps --sort size`
	+ List all processess for all users
		- `ps aux`
		- **a** - Include all users
		- **u** - Display process owner's username
		- **x** - Include processes without a TTY

* Process relationships
	+ Processes can be linked
		- Subprocesses
		- Parent processes
	+ List a process's relationship to other processes
		- `pstree`
		- `pstree <pid>`
		- `pstree <username>`
* Process Memory Map
	+ Processes also hook into libraries
	+ Can be viewed as a memory map using `pmap`
	+ `sudo pmap <pid>`
* Process Open Files
	+ List of files a process may be accessing
	+ `lsof -p <PID>`
* *mpstat*
	+ Displays CPU statistics
	+ Similar to `sar -u` but in real-time
	+ `mpstat 5`
		- Display CPU stats every 5 seconds
