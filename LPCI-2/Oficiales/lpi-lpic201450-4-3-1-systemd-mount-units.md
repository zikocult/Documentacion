## systemd Mount Units  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the structure of a systemd mount unit configuration file. 
2. Differentiate between systemd mount units and the fstab file. 
3. Configure a volume or partition to persistently mount by creating a systemd mount unit. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* systemd Units
    + Simple text files
    + Can define a service, port, timer, mount, etc.
    + Similar to `/etc/fstab`
    + Differences
        - One file for each mount
        - Vertical option format
* Benefits of using systemd units
    + Dependancy heirarchy
        - No more waiting on a disk to mount
        - Easier mount/unmount using `systemctl`
* Required information
    + Desired mount point location
        - Folder must exist prior to mounting
    + File system type
        - ext4, xfs, etc
    + Drive identifier
        - Device Name (e.g. /dev/sda1)
        - Device Label (e.g. Storage)
        - Device UUID (e.g. 7e131497-d38d-4606-8fec-2c8bb9f2e26b)
    + Obtaining drive data
        - `lsblk -f`
        - `blkid`
* Mount Unit File Format
    + Options
        - What - the device name
        - Where - the mount point
        - Type - the file system
        - Options - Mount options
            + defaults
            + ro - Read only
            + user - Allow users to mount
            + nofail - Do not stop if device is missing
        - TimeOutSec - time to wait before failing
* Testing mount units
    + Have *systemd* reparce unit files
        - `systemctl daemon-reload`
    + Trigger the mount operation
        - `systemctl start storage.mount`
    + Verify the mount
        - `systemctl status storage.mount`
        - `lsblk`
    + Enable mounting at boot time
        - `systemctl enable storage.mount`