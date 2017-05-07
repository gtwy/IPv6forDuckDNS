# IPv6forDuckDNS
Script to submit both IPv6 and IPv4 addresses to DuckDNS.

By default, DuckDNS cannot automatically resolve IPv6 addresses (See [DuckDNS FAQ](https://www.duckdns.org/faqs.jsp) for more details.) Using my script will allow you to easily and automatically submit your IPv4 and IPv6 addresses to DuckDNS.

# Understanding IPv6
While your public IPv4 address is shared across all devices in your network using NAT, your public IPv6 address will be differrent on every device. Therefor, you must run this script on the device that is providing the service. Example: If you are setting up a webserver, run this script on the machine that is hosting the website. If you run it from the router, or another computer, it will have an incorrect IPv6 address.

# Installation
1. Edit **duckdns6.sh**
   1. Add your subdomain
   1. Add your DuckDNS token
1. Test it
   1. The script should return "OK"
   1. "K0" is an official error code from DuckDNS - check your subdomain and token
   1. If you get any other output, something is broken. Do you have all necessary packages installed?
1. Create cron job
   1. DuckDNS recommend a 5 minute interval
