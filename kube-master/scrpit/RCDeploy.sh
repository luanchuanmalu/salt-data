echo "Start RCA2B"
rcTag=0  #1 A2B; 2 B2A
rcNum=0  #move number
rcFinishNum=0
rcTotalNum=0 #move total number
#Got the number from temp file
echo "Default rcTag=$rcTag, rcNum=$rcNum, rcFinishNum=$rcFinishNum, rcTotalNum=$rcTotalNum"
tmpFile="/tmp/jenkins/RCDeploy.txt"
if [ -f "$tmpFile" ]
then 
	source $tmpFile
	echo "Got from $tmpFile, rcTag=$rcTag , rcNum=$rcNum ,rcFinishNum=$rcFinishNum, rcTotalNum=$rcTotalNum"
fi
#Got the move number
moveNum=0;
let leftNum=rcTotalNum-rcFinishNum
if((($leftNum) > ($rcNum)))
then
	let moveNum=rcNum
else
	let moveNum=leftNum
	
fi
echo "leftNum=$leftNum, move $moveNum times"
let moveNumTag=moveNum
#Move the RC
rcGroupANumber=$(kubectl get rc | grep "hellogroupa" | tail -c 3)
rcGroupBNumber=$(kubectl get rc | grep "hellogroupb" | tail -c 3)
if [[ 1 -eq $rcTag ]] 
then
  echo "RC move from A2B, move $moveNumTag times"
  while (($moveNumTag))
  do
  	((rcGroupANumber--))
	((rcGroupBNumber++))
	((moveNumTag--))
	numA=0
	numB=0
	let numA=rcGroupANumber
	let numB=rcGroupBNumber
	kubectl scale --replicas=$numA replicationcontrollers hellogroupa
	kubectl scale --replicas=$numB replicationcontrollers hellogroupb
	kubectl get rc
  done
elif [[ 2 -eq $rcTag ]]
 then
  echo "RC move from B2A, move $moveNumTag times"
  while (($moveNumTag))
  do
	((rcGroupANumber++))
	((rcGroupBNumber--))
	((moveNumTag--))
	numA=0
	numB=0
	let numA=rcGroupANumber
	let numB=rcGroupBNumber
	kubectl scale --replicas=$numA replicationcontrollers hellogroupa
	kubectl scale --replicas=$numB replicationcontrollers hellogroupb
	kubectl get rc
  done
fi
let rcFinishNum=rcFinishNum+moveNum
echo "Move finished, rcFinishNum=$rcFinishNum"
if((($rcTotalNum) > ($rcFinishNum)))
then
  sh /tmp/JenkinsScript/Deploy_tmp.sh $rcTag $rcNum $rcFinishNum $rcTotalNum 

else
  echo "All move done, remove the file $tmpFile"
  rm $tmpFile
  #Check the status of RC
  echo "Check the RC status "
  rcGroupANumber=$(kubectl get rc | grep "hellogroupa" | tail -c 3)
  rcGroupBNumber=$(kubectl get rc | grep "hellogroupb" | tail -c 3)
  if ((($rcGroupANumber) && ($rcGroupBNumber)))
  then
  	echo "All RC move done, but RC not clean"
  	exit -1;
  fi
fi

echo "End RCA2B"
