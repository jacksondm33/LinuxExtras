sysctl -w net.ipv4.ip_forward=1 | echo -n
if iptables -t nat -A PREROUTING -i $1 -p tcp --dport $2 -j REDIRECT --to-port $3
then
exit 0
fi
exit 1

