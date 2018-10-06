#!/bin/bash

# the wacom touch device to toggle
touch="Wacom ISDv5 326 Finger touch"

# get the current status of the device
state="$(xsetwacom --get "$touch" Touch)"

echo -e "intial status: $state\n"

# if Touch is enabled, disable it, else enable it
test on == $state && ( xsetwacom --set "$touch" Touch off; echo -e "Touch disabled\nfinal status: off" ) || ( xsetwacom --set "$touch" Touch on; echo -e "Touch enabled\nfinal status: on" )

