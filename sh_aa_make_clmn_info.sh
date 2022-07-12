#! /bin/sh

#=================================
# Making column information per each table
# How to use: sh sh_aa_make_clmn_info.sh
# Caution: clmn_info folder should be empty before excuting this shell
#=================================

cpath='./clmn_info/'
rmcolumn="rm ${cpath}*.*"

# eval $rmcolumn

while read line
do
	set -A list ${line}
	fname=$cpath${list[0]}.txt
	
	if [ -e $fname ]
	then
		echo ", ${list[1]}" >> $fname
	else
		echo ${list[1]} >> $fname
	fi
done < TABLE_COLUMN.txt

exit 0
