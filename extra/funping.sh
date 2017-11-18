st=0
while [ $st -eq 0 ]
do
timew=`fping $1 -e | grep " ms" | awk '{print $4;}'`
timed=${timew:1:4}
time=$(echo | awk "{print $timed*100;}")
cnt=0
if [ $time = "" ]
then
continue
fi
while [ $cnt -le `expr $time / 100` ]
do
echo -e -n "\e[32m*\e[39m"
cnt=`expr $cnt + 1`
done
if [ $time -le $2 ]
then
echo -e "     $time"
else
echo -e "     \e[101m$time\e[49m"
fi
done
