## Managing systemd  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Determine if a system is running systemd.
2. Describe the function of systemd targets and switch between them.
3. Use the systemctl command to control background services. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Almost all modern distros use systemd
	+ Process ID #1
		- `ps aux`
		- `init`
		- `systemd`
	+ `ls -l /sbin/init`
* Daemons
	+ Services/Applications
	+ Run in the background
* Unit Files
	+ Define the service
	+ `/lib/systemd/system/`
* Can be overridden
	+ `/etc/systemd/system/`
* Targets
	+ Define a collection of units to execute
	+ Establishes dependencies and a hierarchy
	+ `/lib/systemd/system/graphical.target`
	+ `ls -l /lib/systemd/system/*.target`
* Default target
	+ Whatever target is symlinked to `/etc/systemd/system/default.target`
	+ `systemctl get-default`
* `sudo systemctl set-default multi-user.target`
* Unit Files
	+ Define the service
	+ `/lib/systemd/system/`
* Enabling a service
	+ `sudo systemctl enable httpd`
	+ `sudo systemctl enable --now httpd`
* Create custom units
	+ Place them in `/etc/systemd/system/`
	+ Reload configuration files
		- `systemctl daemon-reload`
