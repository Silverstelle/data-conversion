#! /bin/sh

#=================================
# Replace '\' with ''
# How to use: sh sh_aa_replace.sh TABLE_NAME
#=================================

table_name=$1

if [ -e unload_dir/${table_name}.dat ]
then
	sed s/'\\ '/''/g unload_dir/${table_name}.dat > dat_dir/${table_name}.dat
	
	echo "**********************************"
	echo "* Trash data from ${table_name}.dat has been deleted."
	
	line_unload=`wc -l unload_dir/${table_name}.dat`
	line_dat=`wc -l dat_dir/${table_name}.dat`
	
	echo "* UNLOAD directory: ${line_unload%%unload*dat}"
	echo "* DAT    directory: ${line_dat%%dat*dat}"
	
	if [ ${line_unload%%unload*dat} -eq ${line_dat%%dat*dat} ]
	then
		rm unload_dir/${table_name}.dat
		echo "* (UNLOAD directory) "${table_name}".dat has been deleted *"
	else
		echo "*** The number does not match!"
		echo "*** (UNLOAD directory) "${table_name}".dat has NOT been deleted."
	fi
	echo "**********************************"
else
	echo "**********************************"
	echo "*** (UNLOAD directory) "${table_name}".dat file does NOT exist. "
	echo "*** Please check UNLOAD SQL!"
	echo "**********************************"
fi

exit 0
