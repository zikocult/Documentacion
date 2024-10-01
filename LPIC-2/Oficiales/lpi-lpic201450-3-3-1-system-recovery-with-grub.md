## System Recovery with GRUB  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the purpose and function of the GRUB bootloader.
2. Modify and update GRUB configuration files. 
3. Reinstall GRUB to correct a damaged installation.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* **GR**and **U**nified **B**ootloader (GRUB)
	+ GRUB 2
	+ Open source boot loader
* Features
	+ Multiple architectures
	+ Graphical menus
	+ Rescue mode
	+ Modules
* Menu entries
	+ Point to operating systems on disk
	+ Point to kernels
* GRUB-related Issues
	+ Dual booting operating systems
		- May overwrite GRUB
		- May not be detected
		- GRUB does not update its list automatically
	+ Manual configuration
		- Human error (typos)
		- Hard coded kernel versions aren't updated
	+ Disk encryption
		- May overwrite GRUB
* Modifying GRUB Parameters (e.g. timeout)
	1. `sudoedit /etc/default/grub`
	2. `update-grub2`
* GRUB Configuration
	+ Ubuntu: `/boot/grub/grub.cfg`
	+ RHEL: `/boot/grub2/grub.cfg`
	+ Should not be edited directly
* Correcting GRUB Menu Entries
	+ Different configurations for different distros
		`/boot/grub/menu.lst` 
		`/boot/grub/grub.conf`
		`/etc/default/grub`
* Example: Ubuntu
	+ Menu is automatically generated at boot
	+ Uses scripts in `/etc/grub.d` to build
	+ Copy an existing entry
		- `less /boot/grub/grub.cfg`
		- Search for `menuentry`
	+ `sudoedit /etc/grub.d/40_custom`
	+ Push the Update
		- `sudo update-grub`
		- `sudo grub-mkconfig`
			+ Displays potential config
		- `sudo grub-mkconfig -o /boot/grub/grub.cfg`
			+ Installs the config
* Updating GRUB when you can't boot
	1. Boot from a LiveCD or attach to another system
	2. Find the appropriate disk
		- `lsblk -f`
		- `blkid`
	3. Mount the Disk
		- `sudo mount /dev/sda1 /mnt/sda1`
	4. Reinstall GRUB
		- `sudo grub-install --root-directory=/mnt/sda1 /dev/sda`
	5. Unmount the disk
		- `sudo umount /dev/sda1`
	6. Reboot

```
menuentry 'Ubuntu (Init Test)' --class ubuntu --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-a8af722f-c40a-4f72-844b-8afbbaa6b742' {
        recordfail
        load_video
        gfxmode $linux_gfx_mode
        insmod gzio
        if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
        insmod part_msdos
        insmod ext2
        insmod raid10
        set root='hd0,msdos5'
        if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos5 --hint-efi=hd0,msdos5     --hint-baremetal=ahci0,msdos5  a8af722f-c40a-4f72-844b-8afbbaa6b742
        else
          search --no-floppy --fs-uuid --set=root a8af722f-c40a-4f72-844b-8afbbaa6b742
        fi
        linux   /boot/vmlinuz-5.8.0-55-generic root=UUID=a8af722f-c40a-4f72-844b-8afbbaa6b742 r    o find_preseed=/preseed.cfg auto noprompt priority=critical locale=en_US quiet
        initrd  /boot/initrd.img-5.8.0-55-don
}
```