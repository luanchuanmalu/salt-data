echo "Start RCNewDeploy"
groupa=$1
groupb=$2
scriptpath=$3
echo "groupa=$groupa, groupb=$groupb, scriptpath=$scriptpath"
#scriptpath="/srv/keystone-ops-salt/kube-master/scrpit"
#groupa="hellogroupa"
#groupb="hellogroupb"
rcTag=0  #1 A2B; 2 B2A
rcNum=0  #move number
rcFinishNum=0
rcTotalNum=0 #move total number

#Initial a rcNum, or we can get from $ external
rcNum=1

#Initial other by kubes
rcGroupANumber=0
rcGroupBNumber=0
rcGroupANumber=$(kubectl get po | egrep $groupa-* | wc -l)
rcGroupBNumber=$(kubectl get po | egrep $groupb-* | wc -l)
if ((($rcGroupANumber) && ($rcGroupBNumber)))
then
  echo "GroupARC=$rcGroupANumber or GroupBRC=$rcGroupBNumber not clean"
  exit -1
elif (($rcGroupANumber))
then
  echo "Transfer RC from $groupa to $groupb"
  let rcTag=1
  let rcTotalNum=rcGroupANumber
elif (($rcGroupBNumber))
then
  echo "Transfer RC from $groupb to $groupa"
  let rcTag=2
  let rcTotalNum=rcGroupBNumber
fi
#Write the RCDeploy.txt
sh $scriptpath/Deploy_tmp.sh $rcTag $rcNum $rcFinishNum $rcTotalNum $groupa
sleep 5
sh $scriptpath/RCDeploy.sh $groupa $groupb $scriptpath
echo "End RCNewDeploy"
