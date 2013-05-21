#!/bin/bash

if [ "x$1" == "xtcp" ]; then
    grep tcp /proc/net/nf_conntrack | wc -l
elif [ "x$1" == "xtcpEstablished" ]; then
    grep ESTABLISHED /proc/net/nf_conntrack | wc -l
elif [ "x$1" == "xudp" ]; then
    grep udp /proc/net/nf_conntrack | wc -l
elif [ "x$1" == "xdhcpLeases" ]; then
    cat /var/lib/misc/dnsmasq.leases | wc -l
elif [ "x$1" == "xtemp" ]; then
    cat /sys/class/thermal/thermal_zone0/temp
fi
