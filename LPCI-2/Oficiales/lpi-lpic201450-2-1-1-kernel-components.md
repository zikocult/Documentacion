## Kernel Components  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the Linux kernel and identify its components.
2. Locate and utilize the Linux kernel documentation.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Operating System Kernels
	+ Allow software to access hardware
	+ Allocate hardware resources to fulfill software requests
	+ Handle multitasking events
	+ Acts as a traffic cop to resources
* The Linux Kernel
	+ Developed by Linus Torvalds
		- Designed to emulate UNIX
	+ Independent
	+ Open source
	+ Combined with resources from countless contributers to form Linux
* The kernel's job
	+ Not the kernel
		- Applications
		- Window Managers
		- GNU Tools
		- Init Systems
	+ The kernel
		- Memory manager
		- Process manager
		- Hardware control
		- Disk file systems
* The Kernel
	+ Typically stored in `/boot`
	+ Many possible filenames
	+ Uncompressed kernel names
		- `kernel`
		- `vmlinux`
	+ Compressed kernel names 
		- `vmlinuz` (The most common)
		- `zImage`
		- `bzImage`
	+ Compression is normally GNU Zip (gzip)
* Monolithic kernels
	+ Monolithic kernels run as one large process
	+ Micro-kernels split the kernel up into multiple processes
	+ Linux is monolithic
	+ The Linux kernel supports loadable modules that expand its function
		- Typically found in `/lib/modules`
		- `/lib/modules/5.8.0-45-generic/kernel`
* Kernel Documentation
	+ May already be installed
		+ `/usr/src/linux/Documentation/`
		+ `/usr/share/doc/linux-doc/`
	+ Installing the documentation
		- `sudo apt install linux-doc`
		- `sudo apt install linux-source`
	+ Written in reStructuredText using Sphinx
		- `make htmldocs`
		- `make pdfdocs`
	+ Or view it online
		- [https://www.kernel.org/doc/html/latest](https://www.kernel.org/doc/html/latest)
* Kernel Headers
	+ Minimum files needed to compile modules
	+ Used to validate function calls against the kernel
		- Does the produced output match what the function would expect?
	+ Much smaller than the full kernel source
