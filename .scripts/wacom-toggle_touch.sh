#!/bin/bash


# first get the touch devices			    | for each of those...
xsetwacom --list devices | ag --nocolor "touch|pad" | while read touch; do

	# get the device id
	#				remove everything after the device name (since there's no '^' this will only match against any number of spaces RIGHT BEFORE 'id' and then the rest of the line) and not also against everything before the spaces...
	touch=$( echo $touch | sed -e 's/[[:space:]]*id.*$//' )
	# Learn from this: You can match against parts of lines, you don't HAVE to match against the whole line
	# Note: I'm using echo cause I need to have a \n for matching against the $

	# get the state
	state="$(xsetwacom --get "$touch" Touch)"

	# print some stuff
	printf "device: $touch\n  intial status: $state\n"

	# if input args have been provided
	if [ "$1" = "on" ]; then
		xsetwacom --set "$touch" Touch on; printf "  Touch enabled\n  final status: on\n"
	elif [ "$1" = "off" ]; then
		xsetwacom --set "$touch" Touch off; printf "  Touch disabled\n  final status: off\n"
	else
		# toggle the state
		test on == $state && ( xsetwacom --set "$touch" Touch off; printf "  Touch disabled\n  final status: off\n" ) || ( xsetwacom --set "$touch" Touch on; printf "  Touch enabled\n  final status: on\n" )
	fi
done
