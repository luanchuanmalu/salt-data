echo "Start RCReset"
groupa=$1
groupb=$2
scriptpath=$3

echo "groupa=$groupa, groupb=$groupb, scriptpath=$scriptpath"
# A2B
rcTag=0  #1 A2B; 2 B2A
rcNum=0  #move number
rcFinishNum=0
rcTotalNum=0 #move total number
#Initial other by kubes
rcGroupANumber=0
rcGroupBNumber=0
rcGroupANumber=$(kubectl get po | egrep $groupa-* | wc -l)
rcGroupBNumber=$(kubectl get po | egrep $groupb-* | wc -l)
let rcTag=1
let rcTotalNum=rcGroupANumber
let rcNum=rcGroupANumber

#scriptpath="/srv/keystone-ops-salt/kube-master/scrpit"
#Write the RCDeploy.txt
sh $scriptpath/Deploy_tmp.sh $rcTag $rcNum $rcFinishNum $rcTotalNum $groupa
sleep 5
sh $scriptpath/RCDeploy.sh $groupa $groupb $scriptpath

# B2A
rcTag=0  #1 A2B; 2 B2A
rcNum=0  #move number
rcFinishNum=0
rcTotalNum=0 #move total number
#Initial other by kubes
rcGroupANumber=0
rcGroupBNumber=0
rcGroupANumber=$(kubectl get po | egrep $groupa-* | wc -l)
#$(kubectl get rc | grep "hellogroupa" | tail -c 3)
#kubectl get po |egrep hellogroupa-*|wc -l
rcGroupBNumber=$(kubectl get po | egrep $groupb-* | wc -l)
let rcTag=2
let rcTotalNum=rcGroupBNumber
let rcNum=rcGroupBNumber
#Write the RCDeploy.txt
sh $scriptpath/Deploy_tmp.sh $rcTag $rcNum $rcFinishNum $rcTotalNum $groupa
sleep 5
sh $scriptpath/RCDeploy.sh $groupa $groupb $scriptpath


echo "End RCReset"
