#!/bin/bash
declare -a arr=("ERR188044" "ERR188104" "ERR188234" "ERR188245" "ERR188257" "ERR188273" "ERR188337" "ERR188383" "ERR188401" "ERR188428" "ERR188454" "ERR204916")

arraylength=${#arr[@]}

##Step 1-3
for (( i=1; i<${arraylength}+1; i++ ));
do
fn=${arr[$i-1]}
echo $fn
hisat2 --dta -x /short_course/chrX_data/indexes/chrX_tran -1 ~/samples/$fn"_chrX_1.fastq.gz" -2 ~/samples/$fn"_chrX_2.fastq.gz" -S $fn"_chrX.sam"
samtools sort -m 40M -o $fn"_chrX.bam" $fn"_chrX.sam"
rm $fn"_chrX.sam"
stringtie -G /short_course/chrX_data/genes/chrX.gtf -o $fn"_chrX.gtf" -l $fn $fn"_chrX.bam"
done

##Step 4
cd ~/samples
postf=.gz
for i in *;do
        fn="${i%$postf}"
        echo $fn
        zcat $i | head -n 100000 > ../samples2/$fn
        gzip ../samples2/$fn
done

##Step 5
cd ~/
for (( i=1; i<${arraylength}+1; i++ ));
do
fn=${arr[$i-1]}
echo $fn
stringtie -e -B -G stringtie_merged.gtf -o ballgown/$fn/$fn"_chrX.gtf" $fn"_chrX.bam"
done
