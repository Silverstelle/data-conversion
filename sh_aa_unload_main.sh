#! /bin/sh

#=================================
# read TABLE_LIST.txt
# excute Unload Shell
#=================================

tblist=$1
sysdsc="AA"
server="server1"

tbcnt=`wc -l ${tblist} | awk {'print $1'}`
count=1

while read line
do

   sqlfile="UN_${sysdsc}_${line}.sql"
   rsltfile="./rslt_dir/${line}.txt"

   echo "********************************"
   echo "* Reading ${tblist}.."
   echo "*"
   echo "* (${count}/${tbcnt}) ${line}"
   
   sdate=`date`
   sdate2=`date +%Y%m%d%H%M%S`

   echo "* USTART TIME: " ${sdate2} > ${rsltfile}
   echo "* START TIME: "${sdate}
   echo "* Unloading .."
   
   dbaccess ${server}db ./sql_dir/${sqlfile} >> ${rsltfile} 2>&1
   
   echo "* Finished unloading! Now replacing trash data"
   sh sh_aa_replace.sh ${line} >> ${rsltfile}
   
   echo "* Finished!"
   
   edate=`date`
   edate2=`date +%Y%m%d%H%M%S`
   
   echo "* E N D TIME: "${edate}
   echo "*UEND TIME:" ${edate2} >> ${rsltfile}
   echo "*"
   
   asiscnt=`grep 'row(s) unloaded' ${rsltfile} | awk {'print $1'}`
   
   echo "* The number of ASIS unloaded table: ${asiscnt}"
   echo "********************************"
   
   count=`expr $count + 1`
   touch ./lst_dir/${line}.txt
   
done < ${tblist}

exit 0
