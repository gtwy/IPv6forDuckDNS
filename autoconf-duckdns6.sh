#!/bin/bash
# shellcheck source=/dev/null
# Autoconfig for DuckDNS IPv4 & IPv6 Update Script v1.0.3
# By James Watt 2017-05-12 Updated 2021-06-07
# This script is intended for hosts with an IPv4 NAT address and a public IPv6 address
set -e

# Paths
baseDir=$(cd "$(dirname "$0")" || exit; pwd -P)
duck6conf="$HOME"/.duck6.conf

# Probe IPv4 and IPv6 addresses
read -r _ _ _ _ iface _ ipv4local <<<"$(ip r g 8.8.8.8 | head -1)"
ipv6addr=$(ip addr show dev "$iface" | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d' | grep -v '^fd00' | grep -v '^fe80' | head -1)

# Does .duck6.conf exist?
if [[ -f "$duck6conf" ]] ; then
  source "$duck6conf"
else
  # Default IPv4 service: https://gtwy.net/ip/
  # Alternate IPv4 service: https://api.ipify.org/?format=txt
  ipv4service="https://gtwy.net/ip/"

  # Questions
  printf "Autoconfigure script by James Watt for DuckDNS.\nThis script should be run on the computer hosting the services you would like publicly accessible.\n\nCheck https://www.duckdns.org/domains for domain and token\n\n"
  read -r -e -p "DuckDNS Subdomain (Do not include \".duckdns.org\"): " duckdomain
  read -r -e -p "DuckDNS Token (E.g. a7c4d0ad-114e-40ef-ba1d-d217904a50f2): " ducktoken

  if [[ "$ipv4local" =~ (^127\.)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.) ]] ; then
    printf "\nWe are detecting a local IPv4 address: %s\nYou must provide an ip4service to lookup your public address.\nPress enter for default lookup service.\n" "$ipv4local"
    read -r -e -p "IPv4 Service [$ipv4service]: " Ripv4service
    ipv4service=${Ripv4service:-$ipv4service}
  else
    ipv4service=""
  fi
fi

# Get IPv4 Address
if [[ -z $ipv4service ]] ; then
  ipv4addr=$ipv4local
else
  ipv4addr=$(curl --ipv4 -s "${ipv4service}")
fi

# Connect to DuckDNS
printf "\nNow connecting to DuckDNS and publishing your IPv6 $ipv6addr"
printf "\nfor domain $duckdomain.duckdns.org with token $ducktoken.\n\n"
curl -s "https://www.duckdns.org/update?domains=$duckdomain&token=$ducktoken&ip=$ipv4addr&ipv6=$ipv6addr"

# Write changes and create cronjob

if [[ -f "$duck6conf" ]] ; then
  exit
else
  printf "\n\nCheck https://www.duckdns.org/domains to ensure it updated with the correct info.\n\n"
  yesNo="Y"
  read -r -e -p "Did it update correctly? [Y/n]" RyesNo
  yesNo=${RyesNo:-$yesNo}
  if [[ "$yesNo" == "Y" || "$yesNo" == "y" || "$yesNo" == "yes" || "$yesNo" == "Yes" ]] ; then
    printf "\n 1. Writing changes to ~/duck6.conf."
    echo "#IPv6 for DuckDNS Config Script. You can make changes to this file." > "$duck6conf"
    {
      echo duckdomain=\""$duckdomain"\"
      echo ducktoken=\""$ducktoken"\"
      echo ipv4service=\""$ipv4service"\"
    } >> "$duck6conf"
    printf "\n 2. Copying this script to ~/duckdns6.sh"
    cp "$baseDir"/autoconf-duckdns6.sh "$HOME"/duckdns6.sh
    printf "\n 3. Setting up cronjob to run every 5 minutes"
    (crontab -l 2>/dev/null; echo "*/5 * * * * ~/duckdns6.sh >/dev/null 2>&1") | crontab -
    printf "\n\nConfiguration complete.\n"
  else
    printf "\n\nThis script will now exit. Please double check your settings and run ./autoconfig-duckdns6.sh again.\n\n"
    exit
  fi
fi
