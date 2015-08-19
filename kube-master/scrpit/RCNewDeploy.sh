echo "Start RCNewDeploy"
rcTag=0  #1 A2B; 2 B2A
rcNum=0  #move number
rcFinishNum=0
rcTotalNum=0 #move total number

#Initial a rcNum, or we can get from $ external
rcNum=3

#Initial other by kubes
rcGroupANumber=0
rcGroupBNumber=0
rcGroupANumber=$(kubectl get rc | grep "hellogroupa" | tail -c 3)
rcGroupBNumber=$(kubectl get rc | grep "hellogroupb" | tail -c 3)
if ((($rcGroupANumber) && ($rcGroupBNumber)))
then
  echo "GroupARC=$rcGroupANumber or GroupBRC=$rcGroupBNumber not clean"
  exit -1
elif (($rcGroupANumber))
then
  echo "Transfer RC from GroupA to GroupB"
  let rcTag=1
  let rcTotalNum=rcGroupANumber
  

elif (($rcGroupBNumber))
then
  echo "Transfer RC from GroupB to GroupA"
  let rcTag=2
  let rcTotalNum=rcGroupBNumber

fi
#Write the RCDeploy.txt
sh /tmp/JenkinsScript/Deploy_tmp.sh $rcTag $rcNum $rcFinishNum $rcTotalNum
sleep 5
sh /tmp/JenkinsScript/RCDeploy.sh
echo "End RCNewDeploy"