echo "Start RCReset"

# A2B
rcTag=0  #1 A2B; 2 B2A
rcNum=0  #move number
rcFinishNum=0
rcTotalNum=0 #move total number
#Initial other by kubes
rcGroupANumber=0
rcGroupBNumber=0
rcGroupANumber=$(kubectl get rc | grep "hellogroupa" | tail -c 3)
rcGroupBNumber=$(kubectl get rc | grep "hellogroupb" | tail -c 3)
let rcTag=1
let rcTotalNum=rcGroupANumber
let rcNum=rcGroupANumber
#Write the RCDeploy.txt
sh /tmp/JenkinsScript/Deploy_tmp.sh $rcTag $rcNum $rcFinishNum $rcTotalNum
sleep 5
sh /tmp/JenkinsScript/RCDeploy.sh

# B2A
rcTag=0  #1 A2B; 2 B2A
rcNum=0  #move number
rcFinishNum=0
rcTotalNum=0 #move total number
#Initial other by kubes
rcGroupANumber=0
rcGroupBNumber=0
rcGroupANumber=$(kubectl get rc | grep "hellogroupa" | tail -c 3)
rcGroupBNumber=$(kubectl get rc | grep "hellogroupb" | tail -c 3)
let rcTag=2
let rcTotalNum=rcGroupBNumber
let rcNum=rcGroupBNumber
#Write the RCDeploy.txt
sh /tmp/JenkinsScript/Deploy_tmp.sh $rcTag $rcNum $rcFinishNum $rcTotalNum
sleep 5
sh /tmp/JenkinsScript/RCDeploy.sh


echo "End RCReset"
