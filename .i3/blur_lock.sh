#!/bin/bash

# Temp image location
IMAGE=/tmp/i3lock.png

# Take a blurry screenshot
~/.i3/scrot-blur -B 10 $IMAGE

# Take a screenshot
# scrot $IMAGE

# Make it blurry
# convert $IMAGE -blur "2x8" $IMAGE		# nicer blur, but slower

# Lock with the temp image as background
i3lock -i $IMAGE

# Remove the temp image
rm $IMAGE



# Alternatively use i3lock++

# scrot-blur is the executable compiled from: github.com/darddan/scrot
# That repo is the code for scrot with the extension of an integrated blur alg
# I didn't want to replace Antergos' scrot with this different one, cause
# maintenance (on a very simple open source program from 2000, I know), so I
# put it into the .i3/ folder
