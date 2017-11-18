i=1
while [ 1 -eq 1 ]
do
value=`cat $2 | head -n $i | tail -n 1`
echo $value
mcrypt -d $1 -k $value 2> /dev/null
i=`expr $i + 1`
done
