## Communicating with Users  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe scenarios where user notifications may be required.
2. Utilize system banners, wall, and other system commands to communicate with active users on a system. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Communicating with users
	+ Useful when multiple people may be using a system
	+ Can communicate status changes
		- Service restart
		- Software updates
		- Mount/Unmount storage
		- Network reconfigurations
		- Scheduling a maintenance window
* Login banners
	+ `/etc/issue`
		- Displayed to local (console) users prior to login
	+ `/etc/issue.net`
		- Displayed to remote (telnet) users prior to login
	+ `/etc/motd`
		- Displayed to all users after login
* Writting to a user's terminal
	+ Useful if they are already logged in
	+ Can be done with the `wall` command
	+ Messaging must be enabled
		- It is usually on by default
		- `mesg` displays messaging status
		- `mesg y` or `mesg n` to toggle
	+ Sending a message
		1. Find the user's terminal ID
			+ `w` or `who`
		2. Open the connection
			+ `wall dpezet pts/0`
		3. Type your messages
		4. `Ctrl-D` to end
* System notifications with `wall`
	+ Some commands integrate with `wall` for notifications
	+ Example: `shutdown`
		- `sudo shutdown -r +10 "The system will shutdown in 10 minutes"`
		- `sudo shutdown -c`
