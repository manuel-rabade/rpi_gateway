Raspberry Pi gateway
====================

This is a configuration example of a Raspberry Pi as a netowrk gateway
with the following topology:

                                           wan0 : 192.168.10/254
                                           wan1 : 192.168.11/254
    eth0 : 192.168.1/24 -- Raspberry Pi -- wan2 : 192.168.12/254
                                           wan3 : 192.168.13/254
                                           wan4 : x.x.x/y

The Raspberry Pi is a model B 512 MB that runs ArchLinux ARM
2013-02-11 with five USB Ethernet dongles connected to the Internet
via:

- 4 consumer grade fiber optic links with gateways that do NAT. The
  gateway addresses are 192.168.10.254, 192.168.11.254, 192.168.12.254
  and 192.168.13.254

- 1 dedicated link with a gateway on the address z.z.z.z for the
  x.x.x.x/y network

The LAN is connected to the Ethernet port on board the Raspberry
Pi. The network interface configuration for the Raspberry Pi is:

    eth0: 192.168.1.254
    wan0: 192.168.10.1
    wan1: 192.168.11.1
    wan2: 192.168.12.1
    wan3: 192.168.13.1
    wan4: w.w.w.w

The LAN address distribution and their Internet routes are:

    FROM            TO              DEVICES             INTERNET LINK
    
    192.168.1.1     192.168.1.9     Servers             wan4
    192.168.1.10    192.168.1.49    DHCP fixed by MAC   wan0
    198.168.1.150   192.168.1.249   DHCP dynamic        wan1, wan2, wan3
    192.168.1.250   192.168.1.254   Network gear        wan4

Review the `rpi_gateway.sh` script to see the routing rules and
forwarded ports.

Setup
-----

1.  Aliases for the Ethernet USB dongles

    Create `/etc/udev/rules.d/10-network.rules`

2.  Network manager

    Disable the default network manager: `systemctl disable
    netcfg@ethernet-eth0.service`

    Modify `/etc/network.d/ethernet-eth0`, `/etc/conf.d/netcfg` and
    `/etc/sysctl.conf`

    Create `/etc/network.d/ethernet-wan0`,
    `/etc/network.d/ethernet-wan1`, `/etc/network.d/ethernet-wan2`,
    `/etc/network.d/ethernet-wan3` and `/etc/network.d/ethernet-wan4`

    Enable the network manager: `systemctl enable netcfg`

3.  Gateway scripts

    Create `/root/rpi_gateway/rpi_gateway.sh`,
    `/root/rpi_gateway/lib.sh` and
    `/etc/systemd/system/rpi_gateway.service`

    Enable the gateway service: `systemctl enable rpi_gateway`

4.  DNS and DHCP

    Install Dnsmasq: `pacman -S extra/dnsmasq`

    Modify `/etc/dnsmasq.conf` and create `/etc/ethers`

    Enable the Dnsmasq service: `systemctl enable dnsmasq`

Tips
----

- `if [ -f $file.orig ]; then diff -u $file.orig $file; fi` where
  `$file` could be any in this repo
