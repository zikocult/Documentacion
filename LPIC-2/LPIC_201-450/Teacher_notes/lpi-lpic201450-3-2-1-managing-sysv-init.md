## Managing SysV Init  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Determine if a system is running SysVinit.
2. Describe the function of init runlevels and switch between them.
3. Use the service and chkconfig commands to control background services. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* SysVinit at startup
	+ SysVinit runs the `/etc/rc.d/rc.sysinit` script
	+ On some older systems `/etc/rc.local` when init finishes
* Runlevels: 
	+ 0 - Halt
	+ 1 - Single user mode
	+ 2 - Multiuser text mode without networking
	+ 3 - Multiuser text mode
	+ 4 - Unused
	+ 5 - Multiuser with GUI
	+ 6 - Reboot
	+ NOTE: Can vary between distros
* Runlevel config files
	+ Each runlevel maintains its own
	+ `/etc/rc.d/rc#.d`
	+ May just contain symlinks to `/etc/init.d/`
* Set the default runlevel in `/etc/inittab`
* Verify runlevel (two ways)
	+ `runlevel`
		- Returns two values, eg `N 5`
		- `N` means it has not changed since boot
		- `5` means current runlevel of 5
	+ `who -r`
		- Displays the current runlevel
* Changing the runlevel
	1. Gather some information: 
		- `who` (See who is logged in)
		- `who -r` (See the current runlevel)
	2. Run `init #`
* Configuring a service to start at boot
	+ `chkconfig httpd <on|off>`
	+ `chkconfig --list`
	+ `chkconfig --level 235 mysqld on`
* Managing a service
	+ `service httpd start`
	+ `service httpd stop`
	+ `service httpd restart`
	+ `service httpd status`
