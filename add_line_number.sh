#!/bin/bash
awk '{print "R"NR-1 "\t" $0}' $1  > test
mv test $1
