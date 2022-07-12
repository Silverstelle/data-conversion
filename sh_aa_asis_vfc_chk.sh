#! /bin/sh

#=================================
# 
#=================================

sum_tblist=$1
cnt_tblist=$2

sysdsc="AA"
sysdsc_small="aa"
aserver="asisserver"
tserver="server1"
pswd="123456789!"
userid="'ID/${pswd}@${tserver}'"

ex_tbloader="tbloader userid=${userid} control=./ctl_dir/"

category=""
vfctable="TB_FA_${sysdsc}_VRT"

sdate=`date`
echo "ASIS verification start: "${sdate}

#---------------------------------
# Uploading information (INF)
#---------------------------------
category="INF"

echo "**********************************"
echo "* Uploading information .."
eval "${ex_tbloader}CTL_${sysdsc}_${vfctable}_${category}.ctl errors=-1"
echo "**********************************"

rm ./dat_dir/${vfctable}_SUM.dat
rm ./dat_dir/${vfctable}_CNT.dat
rm ./dat_dir/${vfctable}_APL.dat

#---------------------------------
# Uploading sum (SUM)
#---------------------------------
category="SUM"
sum_tbcnt=`wc -l ${sum_tblist} | awk {'print $1'}`
count=1

echo "**********************************"
while read line
do
	loadlist="./vfc_dir/ASIS_${line}_${category}.sql"
	
	echo "* (${count}/${sum_tbcnt}) ${line} Unloading sum .."
	echo ${loadlist}
	dbaccess ${aserver}db ${loadlist}
	
	cat ./vfc_dir/ASIS_${line}_SUM.unl >> ./dat_dir/${vfctable}_${category}.dat
	count=`expr $count + 1`
done < ${sum_tblist}

echo "* Loading SUM file .."
eval "${ex_tbloader}CTL_${sysdsc}_${vfctable}_${category}.ctl errors=-1"
echo "**********************************"

#---------------------------------
# Uploading sum (CNT)
#---------------------------------
category="CNT"
cnt_tbcnt=`wc -l ${cnt_tblist} | awk {'print $1'}`
count=1

echo "**********************************"
while read line
do

done < ${cnt_tblist}

echo "* Loading CNT file .."
eval "${ex_tbloader}CTL_${sysdsc}_${vfctable}_${category}.ctl errors=-1"
echo "**********************************"

#---------------------------------
# Uploading attached file (APL)
#---------------------------------
category="APL"

echo "**********************************"
echo "* Unloading attached file .."
dbaccess ${aserver}db ./vfc_dir/ASIS_${vfctable}_${category}.sql

echo "* Loading attached file .."
eval "${ex_tbloader}CTL_${sysdsc}_${vfctable}_${category}.ctl errors=-1"

#---------------------------------
# Uploading time file (TIME)
#---------------------------------
category="TIME"

echo "**********************************"
echo "* Collecting convertion time information"

sh sh_${sysdsc_small}_chk_time.sh

echo "* Finished collecting"
echo "* Loading time information .."
eval "${ex_tbloader}CTL_${sysdsc}_${vfctable}_${category}.ctl errors=-1"
echo "**********************************"

#---------------------------------
edate=`date`
echo ""
echo ""
echo "========================================="
echo " ASIS Verification Start: "${sdate}
echo "                   End  : "${edate}
echo "========================================="

exit 0
