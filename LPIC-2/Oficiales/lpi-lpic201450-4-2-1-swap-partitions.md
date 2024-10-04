## Swap Partitions  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the purpose and function of a swap partition. 
2. Determine the appropriate size of a swap partition for a system. 
3. Manually create and activate a swap partition from the Linux CLI. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Swap
    + Not strictly necessary
    + Virtual memory used when we run out of physical memory
    + Can be a disk, volume, or file
* Monitoring memory
    + Swap is only needed when you run out of RAM
    + `free -h`
    + `swapon -s`
    + If you are low on memory you may need to
        1. Troubleshoot memory consumption
        2. Upgrade your RAM
        3. Add swap space
* Determining swap amount
    + [Ubuntu SwapFaq](https://help.ubuntu.com/community/SwapFaq)
    + General rules
        - Minimum of 1GB of Swap
        - When in doubt, set your swap to match your RAM
    + Per Canonical
        - Minimum of round(sqrt(RAM))
        - Maximum of 2(RAM)
* Creating swap space
    + Disk based swap
        1. `sudo mkswap /dev/sda1`
    + File based swap
        1. `sudo dd if=/dev/zero of=/var/swap bs=1M count=2048`
        2. `sudo chmod 600 /var/swap`
        3. `sudo mkswap /var/swap`
* Activating Swap
    + `sudo swapon /var/swap`
    + `sudo swapon /dev/sda1`
* Adding swap to the filesystem table
    1. `sudoedit /etc/fstab`
    2. Add entries for each swap location
        + `/var/swap swap swap defaults 0 0`
        + `/dev/sda1 swap swap defaults 0 0`
* Changing swap
    + General steps
        1. Disable the swap
        2. Modify it
        3. Re-enable it
    + Caution
        - Running without swap may hang the system
        - Make sure you have secondary swap
* Multiple swap locations
    + Used in order of priority
        - `swapon -s`
    + Priority 0 through 32,767
        - Swap is used from highest to lowest
        - Simultaneous if priority is equal
    + Setting priority
        - `sudo swapon -p 10 /dev/sda1`
        - In `/etc/fstab` use the "pri=10" option
