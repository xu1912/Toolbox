#!/bin/bash
while read line;do
        cols=( $line )
        echo ${cols[0]}
done < $1
