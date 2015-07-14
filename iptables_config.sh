#!/bin/bash

##############################
#
#  Quick instructions on opening a port for inbound traffic:
#  
#  "-A INPUT" appends this rule at the end of the chain, put your rule
#  in the chain where it belongs within this script.
#  
#  "-p [protocol]" will restrict the rule to tcp, udp, icmp, or any
#  network protocol. Check manpages for more options for each.
#  
#  "--dport [port number]" specifies port, must specifiy tcp or udp
#  before this, or will throw an error!
#  
#  "-j [action]" will jump to your action when this rule is matched,
#  usually either ACCEPT or DROP.
#  
##############################

# Before doing anything, make sure we don't drop our ability to connect!
iptables -P INPUT ACCEPT

# Then flush out all old rules
iptables -F

# Allow all packets belonging to established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow access from localhost on loopback device
iptables -A INPUT -i lo -j ACCEPT

# First things first, we'll need SSH access
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Webserver on port 80 and 443 (for https)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Close up all the other inbound ports without specific rules above
iptables -P INPUT DROP

# We're not using the computer as a router, so don't neet NAT or forwarding:
iptables -P FORWARD DROP

# We trust outbound traffic from this machine
iptables -P OUTPUT ACCEPT

# and finally save our rules to be applied at next boot
/sbin/service iptables save
