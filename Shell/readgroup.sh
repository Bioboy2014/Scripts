#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=10gb
#PBS -l walltime=10:00:00

cd $PBS_O_WORKDIR


for i in `ls *.bam | sed 's/@//'`
do
   echo $i
   if [ ! -e $i.group.bam ]; then
   java -jar /opt/picard/1.81/AddOrReplaceReadGroups.jar VALIDATION_STRINGENCY=LENIENT I=$i O=$i.group.bam ID="null" LB=HEG4_2.3 PL=illumina PU=00 SM=HEG4
   fi
done

