dump="`iw dev $WIFI_DEV scan`"
ssid_list=`echo "$dump" | grep SSID`
power_list=`echo "$dump" | grep signal`
i=1
while [ 1 -eq 1 ]
do
ssid=`echo "$ssid_list" | head -n $i | tail -n 1`
power=`echo "$power_list" | head -n $i | tail -n 1`
i=`expr $i + 1`
echo "$ssid" "$power"
done
