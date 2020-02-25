#!/bin/sh

# awk to remove optional leading '#' and to uppercase the letters
word="$(echo "$1" | awk -F '#' '{ printf "%s%s\n", toupper($1), toupper($2) }')"
r="$(echo "$word" | cut -b 1,2)"
g="$(echo "$word" | cut -b 3,4)"
b="$(echo "$word" | cut -b 5,6)"

echo "
ibase=16
r=$r; g=$g; b=$b
print r, \",\", g, \",\", b
" | bc
