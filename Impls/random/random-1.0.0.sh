#!/bin/sh

# $1	 how many digits to produce, defaults to 10
 
iconv -c -f ascii -t ascii </dev/urandom | tr -dc '0-9' | head -c ${1:-10}
