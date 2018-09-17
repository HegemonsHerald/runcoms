# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/admin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall



# == MY OWN CHANGES ===================================================

# Zsh settings
# make completion be case-insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
#  zstyle defines lookup styles for zsh.
#  These are context-related and change the behaviour of shell
#  functions, that look, which styles are defined.
#  The completion system uses styles for its completion behaviour and
#  output.
#  The context for the compsys is ':completion:', ':completion:*'
#  matches all other fields of the zstyle commands, for you can get
#  awfully specific using those…
#  The 'matcher-list' is a set of style-rules applied to all completers
#  whenever a completion takes place. 'm:{a-z}={A-Z}' matches lowercase
#  letters to their uppercase counterparts, when the lowercase letters
#  don't return a match. '+m:{A-Z}={a-z}' does the same in the other
#  direction, the '+' adds this rule to the previous instead of
#  overwriting it.

# Set default editor to Vim
EDITOR=/usr/bin/vim
VISUAL=/usr/bin/vim

# Make use Vi-like keybindings
set -o vi

# Ranger Config
RANGER_LOAD_DEFAULT_RC=false
alias ranger='ranger --choosedir=$HOME/.rangerdir; cd "$(cat $HOME/.rangerdir)"; ls;'

# DEFINE ALIASES
alias ls='ls --color -F'
alias asciib='asciib.sh'
alias wtouch='wacom-toggle_touch.sh'
alias chmodx='chmod +x'
alias youtube-dl="youtube-dl -o '%(title)s.%(ext)s'"
alias ran='ranger'
alias fzf='fzf --preview="head -$LINES {}"'
alias :q='exit'
alias sus='suspend.sh'

# DEFINE FUNCTIONS
combine_search(){
	OLD_IFS=$IFS
	IFS="\n"
	ack_res=$(ack -il $1 ./)
	fin_res=$(find ./**/*$1*)
	echo -e "$ack_res\n$fin_res"
	IFS=$OLD_IFS
}

search(){
	combine_search $1 | fzf
}

vsearch(){
	vim $(search $1)
}

source ~/git_prompt_status.sh

# source fancy_prompt.sh

precmd() {
	if $(git_repo); then
		PROMPT="%F{yellow}$(git_current_branch)%f%F{red}∷%f%F{blue}%1~(%f$(git_prompt_status)%F{blue})%f %F{green}»%f "
		RPROMPT="%F{red}%?%f %F{yellow}%T%f"
	else
		PROMPT="%F{blue}%1~%f %F{yellow}%T%f %F{green}»%f "
		RPROMPT="%(?.%F{green}%?%f.%F{red}%?%f"
	fi
}


alias g='git'
alias ga='git add'
alias gp='git push'
alias gc='git commit'
alias gm='git commit -m'
alias gpu='git pull'
alias gf='git fetch'
alias gs='git status'
alias cr='cargo run'
alias cb='cargo build'
alias cdoc='cargo doc'

alias dp='PROMPT="%F{cyan}» "'	# this one doesn't work with precmd
alias qdp='source ~/.zshrc'
