#!/bin/bash
#ping the remote host
/bin/ping -c 2 -W 2 10.1.0.1 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
    logger -t openvpn "Host 10.1.0.1 stopped responding. Restarting VPN..."
    # Disable the vtun1 interface
    sudo ip link set vtun0 down
    logger -t openvpn "vtun0 interface disabled"
    # Wait for a few seconds
    sleep 5

    # Enable the vtun1 interface
    sudo ip link set vtun0 up
    logger -t openvpn "vtun0 interface enabled"
    logger -t openvpn "VPN restarted"
fi
