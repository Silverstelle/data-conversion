#! /bin/sh

#=================================
# Creating control files whose table info is in clmn_info directory
# How to use: sh sh_aa_exe_control.sh
#=================================

cpath='./ctl_dir/'

cd ./clmn_info/
ls -al TB_FA*.txt | awk {'print $9'} | sed s/.txt/''/g > ../CTL_LIST.txt
cd ../

while read line
do
	fname=${cpath}CTL_AA_${line}.ctl
	sh sh_aa_make_control.sh $line > ${fname}
done < CTL_LIST.txt

rm CTL_LIST.txt

exit 0
