# This is a way of connecting an EdgeRouter with a pfSense on a Peer-to-Peer OpenVPN connection.

Generate a secret-key on your EdgeRouter Router:
```
generate vpn openvpn-key /config/auth/secret
```

Now show and save this key to use it on the pfSense server:
```
sudo cat /config/auth/secret
```

```
```

+ Enter EdgeOS configuration mode to add the firewall rules needed using the network-group countries_allowed generated by the script:
```
configure

set firewall name WAN_LOCAL rule 30 action accept
set firewall name WAN_LOCAL rule 30 description Tunnel EdgeRouter-pfSense
set firewall name WAN_LOCAL rule 30 destination port 1197
set firewall name WAN_LOCAL rule 30 protocol udp

set interfaces openvpn vtun0 shared-secret-key-file /config/auth/secret

set interfaces openvpn vtun0 mode site-to-site
set interfaces openvpn vtun0 local-port 1197
set interfaces openvpn vtun0 remote-port 1197

set interfaces openvpn vtun0 remote-host pfsense-server.remote
set interfaces openvpn vtun0 local-host edgerouter.local


set interfaces openvpn vtun0 local-address 10.1.0.2
set interfaces openvpn vtun0 remote-address 10.1.0.1

set protocols static interface-route 10.0.0.0/8 next-hop-interface vtun0
set protocols static interface-route 10.1.0.142/32 next-hop-interface vtun0

set interfaces openvpn vtun0 openvpn-option "--auth SHA256"
set interfaces openvpn vtun0 openvpn-option "--cipher AES-128-CBC"
set interfaces openvpn vtun0 openvpn-option "--comp-lzo"

commit; save
```

# This script will run when the Edgerouter boots. It will:
Traverse the list of countries defined in the top of the script
Download a list of subnets in each country
Add it to the ipset table (thats what the Edgerouter uses for network-groups)

# Manually running the script:
```
/config/scripts/post-config.d/country-load.sh
```

# Testing
After rebooting the edgerouter or manually running the script, you can check that we actually got some subnets in our network-group:
```
sudo ipset -L countries_allowed
```
Dont be fooled by looking in the GUI – it will know nothing about all this happening behind #the scenes!
Be careful!
If you do any change to the network group “countries_allowed” from the GUI, the Edgerouter #will empty the list generated from the script! Don’t do that 🙂

The original idea was found on this website. Thanks for the ideas!
http://www.cron.dk/firewalling-by-country-on-edgerouter/
