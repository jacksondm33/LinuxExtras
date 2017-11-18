while true
do
rssi=$(sudo btmgmt conn-info $1 | awk '/RSSI/ { print $2 }')
if [ $rssi -le -50 ]
then
echo -e -n "\e[31mWARNING: RSSI >= 50\e[39m\r\a"
else
echo -e -n "\r                     \r"
fi
sleep 0.1
done
