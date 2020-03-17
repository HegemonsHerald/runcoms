#!/bin/bash

# If no args are provided, print a help
if [ "$1" = "" ]; then
	echo "Usage: $0                                          show this help
Usage: $0 list                                     list available monitors and tablets
Usage: $0 <tablet ID> <monitor name>               map the wacom tablet with <tablet ID> to the monitor with <monitor name>
Usage: $0 <tablet ID> [all]                        map the wacom tablet with <tablet ID> to all monitors (assuming your monitors are next to each other and not overlapping)
Usage: $0 <tablet ID> [a[bsolute] | r[elative]]     change the mode of the tablet with <tablet ID> to a[bsolute] or r[elative]\n\n"

	# For convenience also output the list command's output
	/bin/bash $0 list
	exit 0
fi

# If the input argument is list, print the available monitors
if [ "$1" = "list" ]; then
	printf "Available Monitors:\n"

	# xrandr outputs the x monitors on the system
	#	 ag matches against connected monitors....		     cut gets just the monitor name
	xrandr | ag '[A-Z]+-[0-9]+.+?[[:space:]][0-9]+x[0-9+]+' | cut -d ' ' -f 1

	# Explanation of the regex:
	# The pattern that is to be found looks sth like this: 'HDMI-0 connected 2560x1440+0+720 ....'
	# Matched Pattern:		'HDMI'  '-'   '0'    ' connected'      ' '       '2560'  'x'  '1440+0+720'
	# Regex (with whitespace):	[A-Z]+   -   [0-9]+       .+       [[:space:]]   [0-9]+   x     [0-9+]+

	printf "\nAvailable Tablets:\n"
	xsetwacom --list devices

	exit 0
fi

# If the user wants to set a mapping, do that
# ... loop over the monitor names
xrandr | ag '[A-Z]+-[0-9]+[[:space:]].+?[[:space:]][0-9]+x[0-9+]+' | cut -d ' ' -f 1 | while read monitor_name
do
	# ... if a monitor name has been provided and matches against an existing monitor
	if [ "$2" = "$monitor_name" ]; then

		# get the coordinates of that monitor
		output=$( xrandr | ag --nocolor -Q "$monitor_name" | cut -d ' ' -f 3 )

		# map the specified tablet to that monitor
		xsetwacom set "$1" maptooutput "$output"

		# exit successfully
		exit 0
	fi
done

# If the user has specified just a tablet ID or a tablet ID and 'all', map the tablet to the entire screenspace
if [ "$2" = "" ] || [ "$2" = "all" ]
then

	# get the summed width of the entire monitor setup (assuming your monitors are next to each other and not overlapping)
	width=0

	# get the widths of the monitors...
	for monitor_width in $(xrandr | ag '[A-Z]+-[0-9]+[[:space:]].+?[[:space:]][0-9]+x[0-9+]+' | cut -d ' ' -f 3 | cut -d 'x' -f 1)
	do
		# ... sum them up
		width=$((width + monitor_width))
	done


	# get the max height of the entire monitor setup
	height=0

	# get the monitor heights...
	for monitor_height in $(xrandr | ag '[A-Z]+-[0-9]+[[:space:]].+?[[:space:]][0-9]+x[0-9+]+' | cut -d ' ' -f 3 | cut -d 'x' -f 2 | cut -d '+' -f 1)
	do
		if [ "$height" -lt "$monitor_height" ]; then
			height=$monitor_height
		fi
	done

	# map the tablet to the entire monitor space
	xsetwacom set "$1" maptooutput "${width}x${height}+0+0"
fi	

# If the user wants to change tablet mode, do that!
if [ "$2" = "r" ] || [ "$2" = "relative" ]
then
	xsetwacom set "$1" mode relative
elif [ "$2" = "a" ] || [ "$2" = "absolute" ]
then
	xsetwacom set "$1" mode absolute
fi

# I think the way this script executes is actually quite clever:
# 
# 1. check for no args at all, if so exit
# 2. check for exactly 'list' as an arg, if so exit
# 3. loop over monitors, if $2 has been provided, it'll match against one of them, if so exit
# 4. if that didn't work, either the monitor has been mispelled or $2 is empty or equal to 'all', if so map tablet to entire screen and exit
# 5. if it's non of those, it's probably mode change, check for that and if so exit
# 
# The clever thing here is, that by putting the checks in the correct order I never have to do a general check, that $1 or $2 or both are provided and equal to something,
# that's needed in the current operation. By moving through the checks like this, all possible cases are automatically handled, that's really neat.
