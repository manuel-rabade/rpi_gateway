#!/bin/bash

function create_route_table {
    ip route flush table $1
    ip route show table main | grep -Ev ^default | while read ROUTE ; do
        ip route add table $1 $ROUTE
    done
    ip route add table $1 default via $2
    ip rule del table $1 2> /dev/null
    ip rule add fwmark $1 table $1
}
