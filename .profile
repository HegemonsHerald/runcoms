#
# ~/.profile
#

# This file contains shell-independent setup commands.  That is, it will set
# shell-independent environment variables (like PATH) and source
# shell-independent script files.
#
# It is invoked by each shell's individual .<shell>_profile file,
# which calls the shell's .<shell>rc file afterwards.
#
# For bash the files are
#       .bash_profile
#       .bashrc
#
# For zsh the files are
#       .zprofile
#       .zshrc

# THIS FILE'S STRUCTURE
#
# This file is structured into two main sections:
#  - platform-independent items at the top
#  - platform-specific items are conditionally executed at the bottom
#
# Each of these sections is sorted as follows:
#  - changes to the PATH variable
#  - shell settings, like LOCALE or HOSTALIASES
#  - application specific environment variables


# General additions to PATH
export PATH="$HOME/.perl6/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Add my command script locations to PATH
export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/.scripts/fd:$PATH"
export PATH="$HOME/.scripts/ln:$PATH"

export LC_LANG=en_US.UTF-8
export LC_LOCALE=en_US.UTF-8
export LANG=en_US.UTF-8
export LOCALE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Limit width of man page display
export MANWIDTH=100

# Make alacritty scale well
export WINIT_HIDPI_FACTOR=1.0
export QT_AUTO_SCREEN_SCALE_FACTOR="True"
export QT_SCALE_FACTOR=2

# Mac specific stuff
if [ $(uname -s) = "Darwin" ]; then

        export PATH="$HOME/.cabal/bin:$PATH"

        export COLORTERM=truecolor

        # Chez Scheme with akku as package manager
        export PATH="$HOME/.env:$PATH"
        export CHEZSCHEMELIBDIRS="$HOME/.env/scheme-env/:./"

fi

# Linux specific stuff
if [ $(uname -n) = "Antergos" ]; then

        # Add custom builds of perl6 to PATH
        # Right now that's rakudo-star, this makes the perl6 debugger work
        export PATH="$HOME/Documents/code/custom_builds/rakudo-star/rakudo-star-2018.06/install/bin:$PATH"
        export PATH="$HOME/Documents/code/custom_builds/rakudo-star/rakudo-star-2018.06/install/share/perl6/site/bin:$PATH"
        export PATH="/home/work/.scripts_experimental/:$PATH"

        export HOSTALIASES=~/.local/hosts

fi
