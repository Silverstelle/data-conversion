#! /bin/sh

#=================================
# Checking how long it took to convert data
# The final file: ./rslt_dir/CHK_TIME.txt
#=================================
cd ./rslt_dir/
sysdsc="AA"

#---------------------------------
# Collecting rows/time from rslt_dir
# Collecting error message from both unloaded ASIS data & loaded TOBE data
# Result file: time_chk.txt, chk_error_t.txt, chk_error_i.txt
#---------------------------------
echo "Collecting information .."

grep ' TIME:' TB_FA_*.txt | sed s/.txt:/''/g | sed s/"*"/''/g > time_chk.txt
grep 'TBR' TB_FA_*.txt > chk_error_t.txt
grep 'Error' TB_FA_*.txt > chk_error_i.txt

#---------------------------------
# Arrange the time by each table
# Result file: ${tablename}_chkey.txt
#---------------------------------
echo "Arranging the time by each table .."

while read line
do
	set -A list ${line}
	tablename=${list[0]}
	time_cat=${list[1]}
	time_chk=${list[3]}
	tbchk=${tablename}_chkey.txt
	
	# Create a new file when it starts 
	if [ $time_cat = 'USTART' ]
	then
		echo $tablename $time_cat $time_chk > $tbchk
	else
		echo $tablename $time_cat $time_chk >> $tbchk
	fi
done < time_chk.txt

#---------------------------------
# Making a list of tables to check time
# A list file: table_list_to_check.txt
#---------------------------------
echo "Making a list of tables to check time .."

ls -al TB_FA_*_chkey.txt | awk {'print $9'} | sed s/_chkey.txt/''/g > table_list_to_check.txt

#---------------------------------
# Matching TOBE table name with ASIS table
# Make sure to create ASIS_TABNM.txt before excuting
# Result file: ${line}_chkey.txt
#---------------------------------
echo "Matching TOBE table name with ASIS table .."

while read line
do
	tbchk=${line}_chkey.txt
	atablename=`grep -w ${line} ../ASIS_TABNM.txt | awk {'print $2'}`
	echo "${line} ASIS ${atablename}" >> $tbchk
done < table_list_to_check.txt

#---------------------------------
# Making the final file (Table name, ASIS rows, Start time, End time)
#---------------------------------
echo "Making the final file .."

touch CHK_TIME.txt
rm CHK_TIME.txt

while read line
do
	tablename=${line}
	atablename=""
	ustarttime=""
	uendtime=""
	lstarttime=""
	lendtime=""
	
	while read line2
	do
		set -A list ${line2}
		category=${list[1]}
		content=${list[2]}
		
		if [ $category = 'ASIS' ]
		then
			atablename=$content
		fi
		
		if [ $category = 'USTART' ]
		then
			ustarttime=$content
		fi
		
		if [ $category = 'UEND' ]
		then
			uendtime=$content
		fi
		
		if [ $category = 'LSTART' ]
		then
			lstarttime=$content
		fi
		
		if [ $category = 'LEND' ]
		then
			lendtime=$content
		fi
	done < ${line}_chkey.txt
	
	echo "${sysdsc}|TIME|${tablename}|${atablename}|${ustarttime}|${uendtime}|${lstarttime}|${lendtime}|" >> CHK_TIME.txt
done < table_list_to_check.txt

#---------------------------------
# Deleting in-process files
#---------------------------------
echo "Deleting in-process files .."

rm table_list_to_check.txt
rm time_chk.txt
rm TB_FA_*_chkey.txt
cp CHK_TIME.txt ../dat_dir/TB_FA_${sysdsc}_TIME.dat

echo "**********************************"
echo "* FINISHED!"
echo "* FILE DIRECTORY: ./rslt_dir/CHK_TIME.txt"
echo "**********************************"

exit 0
