## Troubleshooting Name Resolution  
##### LPIC-2: Linux Engineer (201-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the symptoms that would indicate a name resolution issue. 
2. Examine configuration files for errors. 
3. Utilize nslookup and dig to troubleshoot name servers. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Errors caused by name lookup issues
    + Page not found errors
    + Failed updates
    + Failed SSH/VPN connections
    + Incorrect clock
    + Failed NFS mounts
* Configuration Files
    + RedHat based distros
        - `/etc/sysconfig/network`
    + Debian based distros
        - `/etc/network/interfaces`
    + Check name resolution servers/order
        - `/etc/resolv.conf`
        - `order hosts,bind,nis`
    + Check local name resolution
        - `/etc/hosts`
* Troubleshooting DNS
    + `nslookup`
    + Testing the default server
        - `nslookup www.google.com`
        - `dig www.google.com`
    + Testing an alternative server
        - `nslookup www.google.com 4.2.2.1`
        - `dig @4.2.2.1 www.google.com`
* Viewing a Full DNS Query
    + `dig www.google.com +trace`
* Other services of note
    + `systemd-resolved`
    + `dnsmasq`
    + `openvpn`