#! /bin/sh

cd ./rslt_dir

while true
do
	sdate=`date | awk {'print $4'}`
	usedinfo=`df -g | grep info_imsi`
	set -A list ${usedinfo}
	
	echo ""
	echo "######## MONITORING (JJ) ########"
	echo " Current time : ${sdate}"
	echo " GB blocks    : ${list[1]}"
	echo " Free         : ${list[2]}"
	echo " %Used        : ${list[3]}"
	echo " lused        : ${list[4]}"
	echo " %lused       : ${list[5]}"
	echo "#################################"
	
	echo "\n"
	echo "*********************************"
	echo "*      LOADING TABLE LIST       *"
	echo "*********************************"
	
	if [ -e ../lst_dir/START_*.txt ]
	then
		cd ../lst_dir
		loadcnt=`ls -al START_*.txt | wc -l`
		loadcnt=`expr $loadcnt - 1`
		loadlist=`ls -al START_*.txt | awk {'print $9'} | sed s/.txt/''/g | sed s/START_/''/g`
		set -A tblist ${loadlist}
		count=0
		cd ../rslt_dir
		
		while [ $count -le $loadcnt ]
		do
			second=`tail -1 ${tblist[${count}]}.txt`
			asistabnm=`grep -w ${tblist[${count}]} ../ASIS_TABNM.txt | awk {'print $2'}`
			echo "${tblist[${count}]} (${asistabnm}) -> ${second}"
			count=`expr $count + 1`
		done
	else
		echo "There is NO loading table."
	fi
	
	echo "\n"
	echo "*********************************"
	echo "*        BAD FILE LIST          *"
	echo "*********************************"
	
	if [ -e ../bad_dir/TB_FA*.bad ]
	then
		echo "        TOBE                ASIS"
		badcnt=`ls -al ../bad_dir/TB_FA*.bad | wc -l`
		badcnt=`expr $badcnt - 1`
		badlist=`ls -ltr ../bad_dir | grep -v total | awk {'print $9'} | sed s/.bad/''/g`
		set -A badtable ${badlist}
		bcount=0
		
		while [ $bcount -le $badcnt ]
		do
			asistabnm2=`grep -w ${badtable[${bcount}]} ../ASIS_TABNM.txt | awk {'print $2'}`
			echo "${badtable[${bcount}]}   ${asistabnm2}"
			bcount=`expr $bcount + 1`
		done
	fi
	
	echo "\n"
	echo "*********************************"
	echo "*          LOAD ERROR           *"
	echo "*********************************"
	grep 'TBR' TB_FA_*.txt | uniq | sed s/.txt/' -> '/g
	
	echo "\n"
	echo "*********************************"
	echo "*         UNLOAD ERROR          *"
	echo "*********************************"
	grep 'Error' TB_FA_*.txt | uniq | sed s/.txt/' -> '/g
	echo "\n\n"
	
	sleep 5
	clear
done

exit 0
