d_gateway=$(/sbin/ip route | awk '/default/ { print $3 }' | tail -n 1)
fping -g $d_gateway/24 2> /dev/null | grep alive
