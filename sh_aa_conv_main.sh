#! /bin/sh

#=================================
# executing sh_jj_${table}.sh in TABLE_LIST.txt
#=================================

tblist=$1

tbcnt=`wc -l ${tblist} | awk {'print $1'}`
count=1

while read line
do
	sdate=`date`
	
	echo "**********************************"
	echo "* Reading ${tblist} list .."
	echo "*"
	echo "* (${count}/${tbcnt}) ${line}"
	echo "* START TIME: "${sdate}
	
	sh sh_aa_${line}.sh >> ./rslt_dir/${line}.txt 2>&1
	#rm ./dat_dir/${line}.dat
	
	edate=`date`
	echo "* END TIME: "${edate}
	echo "*"
	
	asiscnt=`grep 'row(s) unloaded' ./rslt_dir/${line}.txt | awk {'print $1'}`
	tobecnt=`grep 'loaded successfully' ./log_dir/${line}.log | awk {'print $1'}`
	
	echo "* ASIS unloaded data: ${asiscnt}"
	echo "* TOBE   loaded data: ${tobecnt}"
	
	if [ -e ./bad_dir/${line}.bad ]
	then
		badcnt=`wc -l ./bad_dir/${line}.bad | awk {'print $1'}`
		echo "*  - The number of bad files: ${badcnt}"
	fi
	
	echo "**********************************"
	echo "\n\n\n"
	
	count=`expr $count + 1`
done < ${tblist}

exit 0
