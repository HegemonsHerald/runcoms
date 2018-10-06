# #!/bin/bash

# get the target workspace number
n="$(cat ~/.i3/target-workspace)"

# move to the target workspace
i3-msg workspace "$n"
# i3-msg workspace 12

# exit specific workspace selection mode
i3-msg mode "default"

# clear target
rm ~/.i3/target-workspace

