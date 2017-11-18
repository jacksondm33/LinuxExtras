while true
do
echo -n -e "\r"
rssi=$(sudo btmgmt conn-info $1 | awk '/RSSI/ { print $2 }')
echo -n "$rssi"
sleep 0.1
done
