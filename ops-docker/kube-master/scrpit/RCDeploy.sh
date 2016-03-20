echo "Start RCA2B"
groupa=$1
groupb=$2
scriptpath=$3
echo "groupa=$groupa, groupb=$groupb, scriptpath=$scriptpath"
rcTag=0  #1 A2B; 2 B2A
rcNum=0  #move number
rcFinishNum=0
rcTotalNum=0 #move total number
#Got the number from temp file
echo "Default rcTag=$rcTag, rcNum=$rcNum, rcFinishNum=$rcFinishNum, rcTotalNum=$rcTotalNum"
tmpFile="/tmp/jenkins/$groupa-RCDeploy.txt"
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
rcGroupANumber=$(kubectl get po | egrep $groupa-* | wc -l)
rcGroupBNumber=$(kubectl get po | egrep $groupb-* | wc -l)
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
	kubectl scale --replicas=$numA replicationcontrollers $groupa
	kubectl scale --replicas=$numB replicationcontrollers $groupb
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
	kubectl scale --replicas=$numA replicationcontrollers $groupa
	kubectl scale --replicas=$numB replicationcontrollers $groupb
	kubectl get rc
  done
fi
let rcFinishNum=rcFinishNum+moveNum
echo "Move finished, rcFinishNum=$rcFinishNum"
if((($rcTotalNum) > ($rcFinishNum)))
then
  sh $scriptpath/Deploy_tmp.sh $rcTag $rcNum $rcFinishNum $rcTotalNum $groupa

else
  echo "All move done, remove the file $tmpFile"
  rm $tmpFile
  #Check the status of RC
  echo "Check the RC status "
  rcGroupANumber=$(kubectl get po | egrep $groupa-* | wc -l)
  rcGroupBNumber=$(kubectl get po | egrep $groupb-* | wc -l)
  if ((($rcGroupANumber) && ($rcGroupBNumber)))
  then
  	echo "All RC move done, but RC not clean"
  	exit -1;
  fi
fi

echo "End RCA2B"
