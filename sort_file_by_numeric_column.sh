#!/bin/bash
## $1 -- file to be sorted
## $2 -- by which column
## $3 -- output file to be saved
sort -t $'\t' -k $2,$2 -V $1 > $3
