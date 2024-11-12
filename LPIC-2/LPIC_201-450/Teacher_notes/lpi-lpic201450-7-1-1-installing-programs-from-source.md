## Installing Programs from Source  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the benefits of installing Linux applications from source.
2. Use GNU utilities to build and install an application from source code. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Reasons to install from source
	+ Latest updates
	+ No package available
	+ Unsupported distro
	+ Code review
	+ Hardware optimization
* Required Tools
	+ Compiler
	+ Libraries
	+ Documentation
* Obtaining source code
	+ Linux repositories
	+ Github
	+ Vendor websites
* Example
	+ John the Ripper
	+ https://www.openwall.com/john/
	+ https://www.openwall.com/john/k/john-1.9.0-jumbo-1.tar.gz
* Validating source code archives
	+ Look for signatures or hashes for the archives
		- https://www.openwall.com/john/k/john-1.9.0-jumbo-1.tar.gz.sign
		- https://www.openwall.com/signatures/openwall-offline-signatures.asc
	+ Validating a signature
		- `gpg --import openwall-offline-signatures.asc`
		- `gpg --verify john-1.9.0-jumbo-1.tar.gz.sign john-1.9.0-jumbo-1.tar.gz`
* Building an application
	1. Obtain the source code
		+ `wget https://github.com/openwall/john/archive/bleeding-jumbo.tar.gz`
	2. Extract the code to a working directory
		+ `tar -xvzf ./bleeding-jumbo.tar.gz`
	3. Perform configuration tasks
		+ `cd john-bleeding-jumbo/src`
		+ `configure`
		+ `sudo apt install libssl-dev`
		+ `configure`
	4. Compile the application
		+ `make`
* Installing the software
	+ Run in-place
		- `../run/john`
	+ Run an install script
		- `./install-sh`
	+ Run the installer
		- `make install`
	+ Install the package
		- `sudo apt install john.deb`

