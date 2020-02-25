#!/bin/sh

echo "
obase=16
r=$1; g=$2; b=$3

if (r < 16) print 0, r else print r
if (g < 16) print 0, g else print g
if (b < 16) print 0, b else print b
" | bc
