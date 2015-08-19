echo "Start Deploy_tmp"
rcTag=0  #1 A2B; 2 B2A
rcNum=0  #move number
rcFinishNum=0
rcTotalNum=0 #move total number
rcTag=$1
rcNum=$2
rcFinishNum=$3
rcTotalNum=$4
tmpPath="/tmp/jenkins/"
tmpFile="/tmp/jenkins/RCDeploy.txt"
if [ ! -x "$tmpPath" ]
then  
	mkdir "$tmpPath"
fi 

echo "Write the rcTag=$rcTag, rcNum=$rcNum, rcFinishNum=$rcFinishNum, rcTotalNum=$rcTotalNum to file $tmpFile"
echo "rcTag=$rcTag">>$tmpFile
echo "rcNum=$rcNum">>$tmpFile
echo "rcFinishNum=$rcFinishNum">>$tmpFile
echo "rcTotalNum=$rcTotalNum">>$tmpFile
#cat /tmp/jenkins/RCDeploy.txt
echo "End Deploy_tmp"
