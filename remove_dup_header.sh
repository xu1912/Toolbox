#!/bin/bash
##Remove duplicate headers while keeping the header at the first line.
##If we combine several files with header into a single file using command cat, duplicated headers will be stored in the new file. Use this command to remove them and only keep the first one.
## Required parameters: $1 -- file name; $2 -- keyword to recognize the header


head -n1 $1 > tmp_$1.out
sed -i "/$2/d" $i
cat $i >> tmp_$1.out
mv tmp_$1.out $1
