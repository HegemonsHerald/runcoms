source ~/.zsh-async/async.zsh

function prompt_time() {
	sleep 1
} 

function completion_cb() {
	# P_TIME=$(date +%H:%M:%S)
	# PROMPT="%F{blue}%1~%f %F{yellow}$P_TIME%f %F{green}»%f "
	zle reset-prompt
}

async init
async_start_worker prompt_time_worker -n
async_register_callback prompt_time_worker completion_cb
async_job prompt_time_worker prompt_time

TMOUT=1
TRAPALRM() {
	async_job prompt_time_worker prompt_time
 }

precmd() {
	P_TIME=$(date +%H:%M:%S)
	# check for git repo
	if $(git_repo); then
		# Prompt for git repos
		PROMPT="%F{yellow}$(git_current_branch)%f%F{red}∷%f%F{blue}%1~(%f$(git_prompt_status)%F{blue})%f %F{green}»%f "
		RPROMPT="%F{red}%?%f %F{yellow}%T%f"
	else
		PROMPT="%F{blue}%1~%f %F{yellow}$P_TIME%f %F{green}»%f "
		RPROMPT="%(?.%F{green}%?%f.%F{red}%?%f"
	fi
}

# the callback function has to update the prompt, because the worker function runs in a pseudoshell
# zle and prompt= commands for some reason always together, probably because my precmd forks up assignment
# timing is off, because async isn't punctual!
#
# Now it only makes one friggin async call, where'd the others go? WHAT?
# OK, so TMOUT needs to be short enough, for this mess to work... IDK
#
# And for some reason I have to assign prompt and zle update in the same function, AND it has to be IN the function.
# otherwise it just doesn't work...
