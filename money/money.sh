if accounts
then
echo -n
else
mkdir accounts
cd accounts
fi
if [ "$2" = "create" ]
then
echo 1000 > $1
exit 0
fi
money=`cat $1`
if [ "$2" = "delete" ]
then
rm $1
exit 0
fi
money=`cat $1`
if [ "$2" = "add" ]
then
echo `expr $money + $3` > $1
money=`cat $1`
fi
if [ "$2" = "subtract" ]
then
echo `expr $money - $3` > $1
money=`cat $1`
fi
if [ "$2" = "multiply" ]
then
echo `expr $money \* $3` > $1
money=`cat $1`
fi
if [ "$2" = "divide" ]
then
echo `expr $money / $3` > $1
money=`cat $1`
fi
if [ "$2" = "" ]
then
cat $1
fi
