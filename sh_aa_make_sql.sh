#! /bin/sh

#=================================
# Read TABLE_SQL.txt and make sql file for each table
#=================================

sysdsc='AA'
spath='./sql_dir/'

cat TABLE_SQL.txt | awk {'print $1'} | uniq > SQL_TABLE.txt

#Removing old sql before creating a new sql 
while read line
do
	rm ./sql_dir/UN_${sysdsc}_${line}.sql
done < SQL_TABLE.txt

#=================================

while read line
do
	set -A list ${line}
	make_sql=${line#$list}
	fname=${spath}UN_${sysdsc}_${list[0]}.sql
	
	echo $make_sql >> ${fname}
done < TABLE_SQL.txt

tablecnt=`wc -l SQL_TABLE.txt`
sqlcnt=`ls -al ./sql_dir/UN_${sysdsc}_TB_FA_*.sql | wc -l | awk {'print $1'}`

echo "${tablecnt} table SQL has been created."
echo "The number of SQL in sql_dir directory: ${sqlcnt}"

exit 0
