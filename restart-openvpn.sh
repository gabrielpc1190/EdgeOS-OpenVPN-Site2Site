#!/bin/bash
#ping the remote host
/bin/ping -c 2 -W 2 192.168.253.2 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
    logger -t openvpn "Host 192.168.253.2 stopped responding. Restarting VPN..."
    # Disable the vtun1 interface
    sudo ip link set vtun1 down
    logger -t openvpn "vtun1 interface disabled"
    # Wait for a few seconds
    sleep 5

    # Enable the vtun1 interface
    sudo ip link set vtun1 up
    logger -t openvpn "vtun1 interface enabled"
    logger -t openvpn "VPN BA restarted"
fi
