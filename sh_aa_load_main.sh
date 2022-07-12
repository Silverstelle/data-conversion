#! /bin/sh

#=================================
# Loading tables in TABLE_LIST.txt
#=================================

tblist=$1
sysdsc="AA"
pswd="123456789!"
server="SERVER1"
userid="'ID/${pswd}@${server}'"
ex_tbloader="tbloader userid=${userid} control=./ctl_dir/"

tbcnt=`wc -l ${tblist} | awk {'print $1'}`
count=1

while read line
do
	loadlist="./lst_dir/${line}.txt"
	ctlfile="CTL_${sysdsc}_${line}.ctl"
	rsltfile="./rslt_dir/${line}.txt"
	
	while true
	do
		if [ -e ${loadlist} ]
		then
			echo "**********************************"
			echo "* Reading ${tblist} list .."
			echo "*"
			echo "* (${count}/${tbcnt}) ${line} Loading start"
			asiscnt=`grep 'row(s) unloaded' ${rsltfile} | awk {'print $1'}`
			echo "* ASIS unloaded data: ${asiscnt}"
			
			sdate=`date`
			sdate2=`date +%Y%m%d%H%M%S`
			echo "* START TIME:" ${sdate}
			echo "* LSTART TIME:" ${sdate2} >> ${rsltfile}
			
			echo "* Loading .."
			mv ${loadlist} ./lst_dir/START_${line}.txt
			loadlist="./lst_dir/START_${line}.txt"
			eval ${ex_tbloader}${ctlfile}" errors=-1 message=100000 rows=1000000" >> ${rsltfile} 2>&1
			
			edate=`date`
			edate2=`date +%Y%m%d%H%M%S`
			echo "* Finished!"
			echo "* E N D TIME:" ${edate}
			echo "* LEND TIME:" ${edate2} >> ${rsltfile}
			
			tobecnt=`grep 'loaded successfully' ./log_dir/${line}.log | awk {'print $1'}`
			echo "* TOBE Loaded data: ${tobecnt}"
			
			if [ -e ./bad_dir/${line}.bad ]
			then
				badcnt=`wc -l ./bad_dir/${line}.bad | awk {'print $1'}`
				echo "*  - The number of bad files: ${badcnt}"
			fi
			echo "**********************************"
			
			rm ${loadlist}
			break
		else
			sleep 10
		fi
			
	done
	
	count=`expr $count + 1`
done < ${tblist}

exit 0
