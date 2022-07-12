#! /bin/sh

#=================================
# Making control file per each table reading column information
# How to use: sh sh_aa_make_control.sh TABLE_NAME
#=================================

table_name=$1
table_file="${table_name}.txt"

cpath="./ctl_dir/"
bpath="./bad_dir/"
dpath="./dat_dir/"
lpath="./log_dir/"
clpath="./clmn_info/"

echo "LOAD DATA"
echo ""
echo "INFILE '$dpath${table_name}.dat'"
echo "LOGFILE '$lpath${table_name}.log'"
echo "BADFILE '$bpath${table_name}.bad'"
echo ""
echo "APPEND"
echo "PRESERVE BLANKS"
echo "INTO TABLE $table_name"
echo ""
echo "FIELDS TERMINATED BY '|'"

#if [ $table_name = 'TB_FA_TABLE' ]
#then
#	echo "        OPTIONALLY ENCLOSED BY '\"'"
#fi

echo "        OPTIONALLY ENCLOSED BY '$^'"
echo "        ESCAPED BY '\\\\\\'"
echo 'LINES TERMINATED BY "\\n"'
#echo 'LINES TERMINATED BY "|\\n"'
echo ""
echo "TRAILING NULLCOLS"
echo "("

while read line
do
	echo $line
done < $clpath${table_file}

echo ")"

exit 0
