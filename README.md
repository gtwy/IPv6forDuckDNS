# IPv6forDuckDNS
Script to submit both IPv6 and IPv4 addresses to DuckDNS.

By default, DuckDNS cannot automatically resolve IPv6 addresses (See [DuckDNS FAQ](https://www.duckdns.org/faqs.jsp) for more details.) Using my script will allow you to easily and automatically submit your IPv4 and IPv6 addresses to DuckDNS.

# Understanding IPv6
While your public IPv4 address is shared across all devices in your network using NAT, each device will have its own public IPv6 address. Therefor, you must run this script on the device that is actually providing the service.

# Prerequisites
* sed
* grep
* curl
* working internet connection w/ dns resolution

# Installation
1. Edit **duckdns6.sh**
   1. Add your subdomain
   1. Add your DuckDNS token
   1. Add your network device. Check **ifconfig** if unsure.
1. Test it
   1. The script should return "OK"
   1. "K0" is an official error code from DuckDNS - check your subdomain and token
   1. If you get any other output, something is broken. *See prerequisites.*
1. Create cron job
   1. DuckDNS recommends a 5 minute interval
   1. You can pipe the output to a log file or /dev/null.
