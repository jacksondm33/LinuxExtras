curl https://www.vpnbook.com/freevpn &> temp_vpn1
cat temp_vpn1 | grep "Password: <strong>" &> temp_vpn2
rm temp_vpn1
cat temp_vpn2 | head -n 1 | awk '{print $2;}' | cut -d'>' -f 2 | cut -d'<' -f 1
rm temp_vpn2
