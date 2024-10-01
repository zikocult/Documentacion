## Monitoring the Kernel  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the structure of the /proc folder and its uses.
2. Use sysctl to view and modify kernel parameters.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Kernel Characteristics
	+ Version
	+ Loaded Modules
	+ Detected Hardware
	+ Performance
* `/proc` folder
	+ Virtual folder
	+ Represents various metrics and settings 
	+ Example: What version is my kernel?
		- `cat /proc/sys/kernel/version`
	+ Example: Tell me about a process
		- `ps aux | grep <executable_name>`
		- `ls /proc/<pid>`
		- `cmdline` Command line input
		- `cwd` Current working directory (Simlink)
		- `exe` Location of executable (Simlink)
		- `environ` Variables
		- `status` General status information
	+ Example: What variables were passed to the kernel at boot
		- `cat /proc/cmdline`
* Accessing kernel details with utilities
	+ Example 1:
		- `cat /proc/sys/kernel/version`
		- `uname -v`
	+ Example 2: 
		- `cat /proc/uptime`
		- `uptime`
	+ Example 3:
		- `cat /proc/modules`
		- `lsmod`
* Changing settings in /proc
	+ It is possible
	+ Use any text editor
		- You will need to own the affected processes or be root
	+ Useful if a proper tool doesn't exist
	+ Generally not advised
* Changing settings with *sysctl*
	+ *sysctl* allows you to change system parameters
	+ Example 1: 
		- Determine maximum open file count: 
			+ `cat /proc/sys/fs/file-max`
			+ `sysctl fs.file-max`
		- Determine quantity of currently open files
			+ `cat /proc/sys/fs/file-nr`
			+ `sysctl fs.file-nr`
		- Change maximum open file limit
			+ `sudoedit /proc/sys/fs/file-max`
			+ `sysctl -w fs.file-max=1000000`
* Making permanent settings
	+ Modify `/etc/sysctl.conf` or add a file to `/etc/sysctl.d/`
		- `sudoedit /etc/sysctl.d/00-custom-settings.conf`
		- `fs.file-max=1000000`
	+ Apply the changes
		- `sudo sysctl -p`
