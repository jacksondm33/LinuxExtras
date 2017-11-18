dgateway=$(/sbin/ip route | awk '/default/ { print $3 }' | tail -n 1)
if [ "$dgateway" = "" ]
then
echo -e "\e[31m[-] No connection found\e[39m"
exit 1
fi
d_length=`expr length $dgateway`
unit_length=`expr $d_length - 1`
unit_ip=${dgateway:0:$unit_length}
scan=`nmap -sn -n ${unit_ip}0/24`
contemp=0
cntmax=0
for word in $scan
do
if [ $contemp -eq 1 ]
then
if [[ $word = *")" ]]
then
finalw=$tempw" "$word
descs=$descs"\n"$finalw
contemp=0
else
tempw=$tempw" "$word
fi
elif [[ $word = "$unit_ip"* ]]
then
ips=$ips"\n"$word
elif [[ $word = ??":"??":"??":"??":"??":"?? ]]
then
cntmax=`expr $cntmax + 1`
macs=$macs"\n"$word
elif [[ $word = "("*")" ]]
then
descs=$descs"\n"$word
elif [[ $word = "("?* ]] && [[ $word != "(0"* ]] && [[ $word != "(1"* ]] && [[ $word != "(2"* ]] && [[ $word != "(3"* ]] && [[ $word != "(4"* ]] && [[ $word != "(5"* ]] && [[ $word != "(6"* ]] && [[ $word != "(7"* ]] && [[ $word != "(8"* ]] && [[ $word != "(9"* ]]
then
tempw=$word
contemp=1
fi
done
cnt=2
cntmax=`expr $cntmax + 1`
while [ $cnt -le $cntmax ]
do
templineip=`echo -e $ips | head -n $cnt | tail -n 1`
templinemac=`echo -e $macs | head -n $cnt | tail -n 1`
templinedesc=`echo -e $descs | head -n $cnt | tail -n 1`
templine=$templineip" >> "$templinemac" "$templinedesc
if [ $cnt -eq 2 ]
then
output=$templine
else
output=$output"\n"$templine
fi
cnt=`expr $cnt + 1`
done
echo -e $output


