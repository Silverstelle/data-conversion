#! /bin/sh

#=================================
# Unloading ASIS data + Loading to TOBE database
# How to use: sh sh_aa_conv_each.sh $1(TABLE NAME) $2(SEPARATOR)
# Separator: U - Unload only, L - Load only, A - Unload & Load
#=================================

TABLENAME=$1
EXE_DSC=$2

if [ $EXE_DSC = 'U' ]
then
	UNLOAD='Y'
	LOAD='N'
fi
if [ $EXE_DSC = 'L' ]
then
	UNLOAD='N'
	LOAD='Y'
fi
if [ $EXE_DSC = 'A' ]
then
	UNLOAD='Y'
	LOAD='Y'
fi

SYSTEM_DSC="AA"
SERVER_ASIS="asisserver"
SERVER_TOBE="server1"
PASSWORD="123456789!"

USERID="'ID/${PASSWORD}@${SERVER_TOBE}'"
EXE_TBLOADER="tbloader userid=${USERID} control=./ctl_dir/"

SQLFILE="UN_${SYSTEM_DSC}_${TABLENAME}.sql"
RESULTFILE="./rslt_dir/${TABLENAME}.txt"
CTLFILE="CTL_${SYSTEM_DSC}_${TABLENAME}.ctl"

#UNLOAD PART
if [ $UNLOAD = 'Y' ]
then
	echo "**********************************"
	echo "* ${TABLENAME} Unloading start .."
	
	SDATE=`date`
	SDATE2=`date +%Y%m%d%H%M%S`
	echo "* USTART TIME:" ${SDATE2} > ${RESULTFILE}
	echo "* START TIME: "${SDATE}
	echo "* Unloading .."
	
	dbaccess ${SERVER_ASIS}db ./sql_dir/${SQLFILE} >> ${RESULTFILE} 2>&1
	
	echo "* Completed! Now replacing trash data"
	sh sh_aa_replace.sh ${TABLENAME} >> ${RESULTFILE}
	
	echo "* Finished!"
	EDATE=`date`
	EDATE2=`date +%Y%m%d%H%M%S`
	echo "* E N D TIME: "${EDATE}
	echo "* UEND TIME:" ${EDATE2} >> ${RESULTFILE}
	echo "*"
	
	COUNT_ASIS=`grep 'row(s) unloaded' ${RESULTFILE} | awk {'print $1'}`
	
	echo "* ASIS unloaded data: ${COUNT_ASIS}"
	echo "**********************************"
fi

#LOAD PART
if [ $LOAD = 'Y' ]
then
	echo "Did you truncate table already?(Y/N)"
	echo "TRUNCATE TABLE ${TABLENAME};"
	
	read answer
	
	if [ $answer = 'Y' ]
	then
		echo "**********************************"
		echo "* ${TABLENAME} Loading start .."
		COUNT_ASIS=`grep 'row(s) unloaded' ${RESULTFILE} | awk {'print $1'}`
		echo "* ASIS unloaded data: ${COUNT_ASIS}"
		
		SDATE=`date`
		SDATE2=`date +%Y%m%d%H%M%S`
		echo "* START TIME:" ${SDATE}
		echo "* LSTART TIME:" ${SDATE2} >> ${RESULTFILE}
		
		echo "* Loading .."
		eval ${EXE_TBLOADER}${CTLFILE}" errors=-1 message=100000 rows=1000000" >> ${rsltfile} 2>&1
		
		EDATE=`date`
		EDATE2=`date +%Y%m%d%H%M%S`
		echo "* Finished!"
		echo "* E N D TIME:" ${EDATE}
		echo "* LEND TIME:" ${EDATE2} >> ${RESULTFILE}
		
		COUNT_TOBE=`grep 'loaded successfully' ./log_dir/${TABLENAME}.log | awk {'print $1'}`
		echo "* TOBE   loaded data: ${COUNT_TOBE}"
		
		if [ -e ./bad_dir/${TABLENAME}.bad ]
		then
			badcnt=`wc -l ./bad_dir/${TABLENAME}.bad | awk {'print $1'}`
			echo "*  - The number of bad files: ${badcnt}"
		fi
		echo "**********************************"
	fi
fi

exit 0
