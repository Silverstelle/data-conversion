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
	ctlfile="CTL_${sysdsc}_${line}.ctl"
	rsltfile="./rslt_dir/${line}.txt"
	
	echo "**********************************"
	echo "* Reading ${tblist} list.."
	echo "*"
	echo "* (${count}/${tbcnt}) ${line} Loading start"
	
	sdate=`date`
	echo "* START TIME :" ${sdate}
	echo "* LSTART TIME:" ${sdate} > ${rsltfile}
	
	echo "* Loading .."
	eval ${ex_tbloader}${ctlfile}" errors=-1 message=100000 rows=1000000" >> ${rsltfile} 2>&1
	
	edate=`date`
	echo "* Finished!"
	echo "* E N D TIME :" ${edate}
	echo "* LEND TIME:" ${edate} >> ${rsltfile}
	
	tobecnt=`grep 'loaded successfully' ./log_dir/${line}.log | awk {'print $1'}`
	echo "* LOADED data: ${tobecnt}"
	
	if [ -e ./bad_dir/${line}.bad ]
	then
		badcnt=`wc -l ./bad_dir/${line}.bad | awk {'print $1'}`
		echo "*  - The number of bad files: ${badcnt}"
	fi
	echo "**********************************"
	
	count=`expr $count + 1`
done < ${tblist}

exit 0
