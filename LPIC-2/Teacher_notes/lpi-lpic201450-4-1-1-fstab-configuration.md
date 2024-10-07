## fstab Configuration  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the structure of the fstab file system table configuration. 
2. Configure a partition or volume to persistently mount by modifying the fstab file.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* The file system table
    + `/etc/fstab`
    + Simple text definition of which volumes to mount at boot time
    + Easy to edit and invoke
    + Has been around a long time
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
* Universally Unique Identifiers (UUID)
    + Unique
        - Device names and labels are often duplicated
    + Assigned to a volume when formatted.
    + Allows identifying the volume even if it moves between systems. 
* Modifying `/etc/fstab`
    + `sudoedit`
    + `fstab` fields
        1. Device ID
            + /dev/sda1
            + LABEL=Storage
            + UUID=7e131497-d38d-4606-8fec-2c8bb9f2e26b
        2. Desired mount point
            + /mnt/storage
        3. File system type
            + ext4
            + xfs
            + auto
        4. Custom options
            + defaults
            + ro - Read only
            + user - Allow users to mount
            + nofail - Do not stop if device is missing
        5. dump configuration
            + 0 - do not dump
            + 1 - dump
        6. File system check
            + 0 - Don't check
            + 1 - Root file system (check first)
            + 2 - Other file system (check second)
* fstab Errors
    + Failure to boot
    + Failure to mount
    + Disk corruption
    + Mounted read only
* Testing the fstab file
    + `sudo mount -a`
