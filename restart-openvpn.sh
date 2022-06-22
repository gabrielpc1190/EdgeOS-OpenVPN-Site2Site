#!/bin/bash
/bin/ping -c 2 -W 2 10.0.0.1 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
       logger -t openvpn "VPN Failed. Restarting..."
       killall -s SIGHUP openvpn
	   logger -t openvpn REYCOM VPN restarted
fi