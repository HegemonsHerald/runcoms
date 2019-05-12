	export CPPFLAGS="-I/usr/local/opt/readline/include"

	export COLORTERM=truecolor
fi

# Main Linux specific stuff
if [ $(uname -n) = "Antergos" ]; then
	# Add custom builds to PATH
	# Right now that's rakudo-star, this makes the perl6 debugger work
	export PATH="$HOME/Documents/code/custom_builds/rakudo-star/rakudo-star-2018.06/install/bin:$PATH"
	export PATH="$HOME/Documents/code/custom_builds/rakudo-star/rakudo-star-2018.06/install/share/perl6/site/bin:$PATH"
fi
