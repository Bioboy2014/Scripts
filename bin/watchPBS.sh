#if you write the PBS parameters in bash script, the memory used in running job will not appear.
#qstat -u cjinfeng |grep -e'^[0-9]\{6\}\.t' | sed 's/\(^[0-9]*\)\.tor.*/qstat -f \1/' | sh | grep -e"Job Id" -e"Job_Name" -e"resources_used.cput" -e"resources_used.mem"
qstat -u cjinfeng |grep -e'^[0-9]\{6,\}\.t' | sed 's/\(^[0-9]*\)\.tor.*/qstat -f \1/' | sh | grep -e"Job Id" -e"Job_Name" -e"resources_used"
