#
# ~/.profile
#

# This file contains shell-independent settings
# such as additions to the PATH variable.
# It is called by each shell's individual .shell_profile file,
# which calls the shell's .shellrc file afterwards.
#
# For bash the files are
#	.bash_profile
#	.bashrc
#
# For zsh the files are
#	.zprofile
#	.zshrc

# Add cargo to PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Add perl6 packages to PATH
export PATH="$HOME/.perl6/bin:$PATH"

# Add ~/Documents/scripts/ to PATH
# note: that's the location of my custom scripts
export PATH="$HOME/.scripts:$PATH"

# Mac Specific Stuff
if [ $(uname -s) = "Darwin" ]; then
	export COLORTERM=truecolor
fi
