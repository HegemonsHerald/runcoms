#!/bin/bash

OLD_IFS=$IFS
IFS="\n"

# find all files and directories, that have $1 in their filename
# remove the first two bytes from each line of output (that's the './')
files=$(find . -ipath "./**/*$1*" -print | cut -b 3-)

# find all files, that contain $1
contents=$(ack -il $1 ./)

# put the results together, remove duplicate listings and put them in alphabetical order
echo -e "$files\n$contents" | sed '/^\s*$/d' | sort -u | fzf -m

IFS=$OLD_IFS
