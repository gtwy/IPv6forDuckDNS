#!/bin/bash
# DuckDNS IPv4 & IPv6 Update Script v0.3
# By James Watt 2017-05-07
# This script is intended for hosts with an IPv4 NAT address and a public IPv6 address

# NOTICE:
# This script has been superseeded by the autoconfig script.
# Please use the autoconfig instead.


# Configure these using your domain and token from https://www.duckdns.org/domains
subdomain="site"    # Do not include ".duckdns.org"
ducktoken="token"   # E.g. "a7c4d0ad-114e-40ef-ba1d-d217904a50f2"

# What device is your IPv6 address bound? Check ifconfig if unsure.
ipv6device="eth0"

# IPv4 Lookup Service
ipv4service="https://ipinfo.io/ip"


# You shouldn't need to edit anything below this line
read ipv6addr < <(ip addr show dev $ipv6device | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d' | grep -v '^fe80')
read ipv4addr < <(curl --ipv4 -s $ipv4service)
curl -s "https://www.duckdns.org/update?domains=$subdomain&token=$ducktoken&ip=$ipv4addr&ipv6=$ipv6addr"


# EOF
