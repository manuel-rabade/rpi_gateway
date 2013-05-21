#!/bin/bash

source /root/rpi_gateway/lib.sh

create_route_table 10 192.168.10.254
create_route_table 11 192.168.11.254
create_route_table 12 192.168.12.254
create_route_table 13 192.168.13.254
create_route_table 5 z.z.z.z

ip route flush cache

iptables -F
iptables -X

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i eth0 -p udp -m multiport --dports 53,67,161 -j ACCEPT
iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable

iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -s 192.168.1.0/24 -j ACCEPT
iptables -A FORWARD -i wan4 -p tcp -m multiport --dports 22,80,443,5000,8080 -j ACCEPT
iptables -A FORWARD -j REJECT --reject-with icmp-proto-unreachable

iptables -t mangle -F
iptables -t mangle -X

iptables -t mangle -A OUTPUT -j MARK --set-mark 5

iptables -t mangle -A PREROUTING -j MARK --set-mark 13
iptables -t mangle -A PREROUTING -p tcp --dport 80 -j MARK --set-mark 12
iptables -t mangle -A PREROUTING -p tcp --dport 443 -j MARK --set-mark 11
iptables -t mangle -A PREROUTING -m iprange --src-range 192.168.1.1-192.168.1.9 -j MARK --set-mark 5
iptables -t mangle -A PREROUTING -m iprange --src-range 192.168.1.10-192.168.1.49 -j MARK --set-mark 10
iptables -t mangle -A PREROUTING -m iprange --src-range 192.168.1.250-192.168.1.254 -j MARK --set-mark 5
iptables -t mangle -A PREROUTING -p tcp --dport 22 -j MARK --set-mark 5

iptables -t nat -F
iptables -t nat -X

iptables -t nat -A POSTROUTING -o wan0 -j SNAT --to-source 192.168.10.1
iptables -t nat -A POSTROUTING -o wan1 -j SNAT --to-source 192.168.11.1
iptables -t nat -A POSTROUTING -o wan2 -j SNAT --to-source 192.168.12.1
iptables -t nat -A POSTROUTING -o wan3 -j SNAT --to-source 192.168.13.1
iptables -t nat -A POSTROUTING -o wan4 -j SNAT --to-source w.w.w.w

iptables -t nat -A PREROUTING -i wan4 -p tcp --dport 5000 -j DNAT --to-destination 192.168.1.1
iptables -t nat -A PREROUTING -i wan4 -p tcp --dport 222 -j DNAT --to-destination 192.168.1.2:22
iptables -t nat -A PREROUTING -i wan4 -p tcp --dport 80 -j DNAT --to-destination 192.168.1.2
iptables -t nat -A PREROUTING -i wan4 -p tcp --dport 443 -j DNAT --to-destination 192.168.1.2
iptables -t nat -A PREROUTING -i wan4 -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.5
