Raspberry Pi gateway
====================

                                           wan0 : 192.168.10/254
                                           wan1 : 192.168.11/254
    192.168.1/24 : eth0 -- Raspberry Pi -- wan2 : 192.168.12/254
                                           wan3 : 192.168.13/254
                                           wan4 : x.x.x/y

The Raspberry Pi is a model B 512 MB that runs ArchLinux ARM
2013-02-11 with five USB Ethernet dongles connected to the Internet
via:

- 4 consumer grade fiber optic services with gateways that do NAT. The
  gateway addresses are 192.168.10.254, 192.168.11.254, 192.168.12.254
  and 192.168.13.254

- 1 dedicated link with a gateway on the address z.z.z.z for the
  x.x.x.x/y network

The LAN address distribution is:

    192.168.1.1     192.168.1.9     Servers and printers
    192.168.1.10    192.168.1.49    DHCP fixed addresses by MAC
    198.168.1.150   192.168.1.249   DHCP dynamic addresses
    192.168.1.250   192.168.1.254   Network devices

The LAN is connected to the Ethernet port on board the Raspberry Pi
and has the 192.168.1.254 address. Pelase review the `gateway` script to
see the routing rules and forwarded ports.

Setup
-----

1.  Aliases for the Ethernet USB dongles

    Create `/etc/udev/rules.d/10-network.rules`

2.  Network

    Modify `/etc/conf.d/netcfg` and `/etc/sysctl.conf`

    Create `/etc/network.d/ethernet-*`

3.  Gateway scripts

    Create `/root/bin/gateway` and `/etc/systemd/system/gateway.service`

    Enable the gateway service: `systemctl enable gateway`

4.  DNS and DHCP

    Install Dnsmasq: `pacman -S extra/dnsmasq`

    Modify `/etc/dnsmasq.conf` and `/etc/ethers`

Tips
----

- `if [ -f $file ]; then diff -u $file.orig $file; fi` where `$file`
  could be any in this repo
