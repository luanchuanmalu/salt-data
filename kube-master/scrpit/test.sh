echo "Start test"
rcTag=1  #1 A2B; 2 B2A
rcNum=3  #move number
rcFinishNum=0
rcTotalNum=10 #move total number
rcPecent=0.3
rcNum=`gawk -v rcFinishNum -v rcPecent'BEGIN{printf "%.2f\n",rcTotalNum*rcTotalNum}'`
echo $rcNum
echo "End test"
