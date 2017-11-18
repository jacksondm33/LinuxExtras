count=$1
while [ "$count" != "0" ]
do
echo -n "$count"
sleep 1
echo -e -n "\r"
echo -n "                    "
echo -e -n "\r"
count=`expr $count - 1`
done
while [ 1 -eq 1 ]
do
echo -e -n "\a"
sleep 1
done
