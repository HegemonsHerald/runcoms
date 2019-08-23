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

export PATH="$HOME/.env:$PATH"

export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/.scripts/fd:$PATH"
export PATH="$HOME/.scripts/ln:$PATH"
export PATH="$HOME/.scripts/old:$PATH"

# Make alacritty scale well
export WINIT_HIDPI_FACTOR=1.0

# Locales for the Vim
export LC_ALL="en_us.utf-8"
export LC_LANG="en_us.utf-8"
export LC_LOCALE="en_us.utf-8"
export LANG="en_us.utf-8"
export LOCALE="en_us.utf-8"

# Mac specific stuff
if [ $(uname -s) = "Darwin" ]; then

	export COLORTERM=truecolor

	export CHEZSCHEMELIBDIRS="$HOME/.env/scheme-env/:./"
fi

# Main Linux specific stuff
if [ $(uname -n) = "Antergos" ]; then
	# Add custom builds to PATH
	# Right now that's rakudo-star, this makes the perl6 debugger work
	export PATH="$HOME/Documents/code/custom_builds/rakudo-star/rakudo-star-2018.06/install/bin:$PATH"
	export PATH="$HOME/Documents/code/custom_builds/rakudo-star/rakudo-star-2018.06/install/share/perl6/site/bin:$PATH"
	export PATH="/home/work/.scripts_experimental/:$PATH"
	export HOSTALIASES=~/.local/hosts
fi
