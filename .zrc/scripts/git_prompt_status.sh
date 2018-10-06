#!/bin/zsh

GIT_PROMPT_PREFIX="%F{green}"
GIT_PROMPT_SUFFIX="%f"

GIT_PROMPT_DIRTY="%F{red}✗%f"
GIT_PROMPT_CLEAN="%F{green}✔%f"
GIT_PROMPT_ADDED="%F{green}✚"
GIT_PROMPT_MODIFIED="%F{yellow}⚑ "
GIT_PROMPT_DELETED="%F{red}✖"
GIT_PROMPT_RENAMED="%F{blue}▴"
GIT_PROMPT_UNMERGED="%F{cyan}§"
GIT_PROMPT_UNTRACKED="%F{white}◒"

function git_prompt_status() {

	# make vars
	local INDEX STATUS

	# get git status and branch
	INDEX=$(command git status --porcelain -b 2> /dev/null)

	# initialize output var
	STATUS=""

	# now for the checking of each case!

	# untracked changes
	if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_UNTRACKED$STATUS"
	fi

	# added files
	if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_ADDED$STATUS"
	elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_ADDED$STATUS"
	elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_ADDED$STATUS"
	fi

	# modified files
	if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_MODIFIED$STATUS"
	elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_MODIFIED$STATUS"
	elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_MODIFIED$STATUS"
	elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_MODIFIED$STATUS"
	fi

	# renamed files
	if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_RENAMED$STATUS"
	fi

	# deleted files
	if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_DELETED$STATUS"
	elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_DELETED$STATUS"
	elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_DELETED$STATUS"
	fi

	# stashed files
	if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
	  STATUS="$GIT_PROMPT_STASHED$STATUS"
	fi

	# unmerged changes
	if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
	  STATUS="$GIT_PROMPT_UNMERGED$STATUS"
	fi

	# ahead of branch
	if $(echo "$INDEX" | grep '^## [^ ]\+ .*ahead' &> /dev/null); then
	  STATUS="$GIT_PROMPT_AHEAD$STATUS"
	fi

	# behind of branch
	if $(echo "$INDEX" | grep '^## [^ ]\+ .*behind' &> /dev/null); then
	  STATUS="$GIT_PROMPT_BEHIND$STATUS"
	fi

	# diverged from branch
	if $(echo "$INDEX" | grep '^## [^ ]\+ .*diverged' &> /dev/null); then
	  STATUS="$GIT_PROMPT_DIVERGED$STATUS"
	fi

	# output!
	echo $STATUS
}

# get the current branch
function git_current_branch() {

	# define vars
	local ref

	# get the current branch name
	ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
	# symbolic-ref follows the HEAD-reference to the branch it refers to and outputs its name

	# get exit status
	local ret=$?

	# if the command comes back with something
	if [[ $ret != 0 ]]; then

		# if 128
		[[ $ret == 128 ]] && return  # no git repo.

		# if anything else, get the branch's id
		ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
		# rev-parse	sorts git's porcelain-output [output for scripts]
		# --short	creates a short log output
	fi

	# output the branch name, without 'refs/heads/'
	echo ${ref#refs/heads/}
}

# are you in a git repo?
function git_repo() {

	# define vars
	local in_repo

	# check, whether you're in a repo or not
	in_repo=$(git rev-parse --is-inside-work-tree 2> /dev/null)
	# 2>	pipes the error output into /dev/null, only if true do we need a return value

	# if you aren't in a repo, return false
	if [[ $in_repo == "true" ]]; then
		echo "true"
		return
	fi

	# if you are in a repo, return true
	echo "false"
	return

}

# get the name of the repo's root directory
function git_toplevel() {
	local top_level
	top_level=$(git rev-parse --show-toplevel)
	echo $top_level
}


# get the current repo name
function git_current_repo() {

	# define vars
	local repo_name

	# if you aren't in a repo, return
	if ! $(git_repo); then
		return
	fi

	# get the repo's name
	repo_name=$(git remote -v | grep fetch | cut -d'/' -f 5 | cut -d'.' -f 1)
	# git remote -v		prints the remote locations git syncs with verbosely
	# grep fetch		gets the fetch location
	# cut			removes selections from lines
	#   cut -d""		cuts the line on the delimiter in ""
	#   -f N		takes the Nth field as delimited by the delimiter
	#   cut -d'/' -f 5	takes the 5th field in a field-list separated by forslashes
	#   cut -d'.' -f 1	takes the first field in a list of .-separated fields


	# output!
	echo $repo_name

}

# ALIASES

alias ga='git add'
alias gf='git fetch'
alias gp='git push'
alias gpu='git pull'
alias cr='cargo run'
alias cb='cargo build'
alias cdoc='cargo doc'

# from the git plugin:
# alias g='git'
# 
# alias ga='git add'
# alias gaa='git add --all'
# alias gapa='git add --patch'
# alias gau='git add --update'
# alias gav='git add --verbose'
# alias gap='git apply'
# 
# alias gb='git branch'
# alias gba='git branch -a'
# alias gbd='git branch -d'
# alias gbda='git branch --no-color --merged | command grep -vE "^(\*|\s*(master|develop|dev)\s*$)" | command xargs -n 1 git branch -d'
# alias gbl='git blame -b -w'
# alias gbnm='git branch --no-merged'
# alias gbr='git branch --remote'
# alias gbs='git bisect'
# alias gbsb='git bisect bad'
# alias gbsg='git bisect good'
# alias gbsr='git bisect reset'
# alias gbss='git bisect start'
# 
# alias gc='git commit -v'
# alias gc!='git commit -v --amend'
# alias gcn!='git commit -v --no-edit --amend'
# alias gca='git commit -v -a'
# alias gca!='git commit -v -a --amend'
# alias gcan!='git commit -v -a --no-edit --amend'
# alias gcans!='git commit -v -a -s --no-edit --amend'
# alias gcam='git commit -a -m'
# alias gcsm='git commit -s -m'
# alias gcb='git checkout -b'
# alias gcf='git config --list'
# alias gcl='git clone --recurse-submodules'
# alias gclean='git clean -fd'
# alias gpristine='git reset --hard && git clean -dfx'
# alias gcm='git checkout master'
# alias gcd='git checkout develop'
# alias gcmsg='git commit -m'
# alias gco='git checkout'
# alias gcount='git shortlog -sn'
# compdef _git gcount
# alias gcp='git cherry-pick'
# alias gcpa='git cherry-pick --abort'
# alias gcpc='git cherry-pick --continue'
# alias gcs='git commit -S'
# 
# alias gd='git diff'
# alias gdca='git diff --cached'
# alias gdcw='git diff --cached --word-diff'
# alias gdct='git describe --tags `git rev-list --tags --max-count=1`'
# alias gds='git diff --staged'
# alias gdt='git diff-tree --no-commit-id --name-only -r'
# alias gdw='git diff --word-diff'
# 
# gdv() { git diff -w "$@" | view - }
# compdef _git gdv=git-diff
# 
# alias gf='git fetch'
# alias gfa='git fetch --all --prune'
# alias gfo='git fetch origin'
# 
# function gfg() { git ls-files | grep $@ }
# compdef _grep gfg
# 
# alias gg='git gui citool'
# alias gga='git gui citool --amend'
# 
# ggf() {
#   [[ "$#" != 1 ]] && local b="$(git_current_branch)"
#   git push --force origin "${b:=$1}"
# }
# ggfl() {
# [[ "$#" != 1 ]] && local b="$(git_current_branch)"
# git push --force-with-lease origin "${b:=$1}"
# }
# compdef _git ggf=git-checkout
# 
# ggl() {
#   if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
#     git pull origin "${*}"
#   else
#     [[ "$#" == 0 ]] && local b="$(git_current_branch)"
#     git pull origin "${b:=$1}"
#   fi
# }
# compdef _git ggl=git-checkout
# 
# ggp() {
#   if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
#     git push origin "${*}"
#   else
#     [[ "$#" == 0 ]] && local b="$(git_current_branch)"
#     git push origin "${b:=$1}"
#   fi
# }
# compdef _git ggp=git-checkout
# 
# ggpnp() {
#   if [[ "$#" == 0 ]]; then
#     ggl && ggp
#   else
#     ggl "${*}" && ggp "${*}"
#   fi
# }
# compdef _git ggpnp=git-checkout
# 
# ggu() {
#   [[ "$#" != 1 ]] && local b="$(git_current_branch)"
#   git pull --rebase origin "${b:=$1}"
# }
# compdef _git ggu=git-checkout
# 
# alias ggpur='ggu'
# compdef _git ggpur=git-checkout
# 
# alias ggpull='git pull origin $(git_current_branch)'
# compdef _git ggpull=git-checkout
# 
# alias ggpush='git push origin $(git_current_branch)'
# compdef _git ggpush=git-checkout
# 
# alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
# alias gpsup='git push --set-upstream origin $(git_current_branch)'
# 
# alias ghh='git help'
# 
# alias gignore='git update-index --assume-unchanged'
# alias gignored='git ls-files -v | grep "^[[:lower:]]"'
# alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
# compdef _git git-svn-dcommit-push=git
# 
# alias gk='\gitk --all --branches'
# compdef _git gk='gitk'
# alias gke='\gitk --all $(git log -g --pretty=%h)'
# compdef _git gke='gitk'
# 
# alias gl='git pull'
# alias glg='git log --stat'
# alias glgp='git log --stat -p'
# alias glgg='git log --graph'
# alias glgga='git log --graph --decorate --all'
# alias glgm='git log --graph --max-count=10'
# alias glo='git log --oneline --decorate'
# alias glol="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
# alias glod="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
# alias glods="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
# alias glola="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
# alias glog='git log --oneline --decorate --graph'
# alias gloga='git log --oneline --decorate --graph --all'
# alias glp="_git_log_prettily"
# compdef _git glp=git-log
# 
# alias gm='git merge'
# alias gmom='git merge origin/master'
# alias gmt='git mergetool --no-prompt'
# alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
# alias gmum='git merge upstream/master'
# alias gma='git merge --abort'
# 
# alias gp='git push'
# alias gpd='git push --dry-run'
# alias gpoat='git push origin --all && git push origin --tags'
# compdef _git gpoat=git-push
# alias gpu='git push upstream'
# alias gpv='git push -v'
# 
# alias gr='git remote'
# alias gra='git remote add'
# alias grb='git rebase'
# alias grba='git rebase --abort'
# alias grbc='git rebase --continue'
# alias grbd='git rebase develop'
# alias grbi='git rebase -i'
# alias grbm='git rebase master'
# alias grbs='git rebase --skip'
# alias grh='git reset'
# alias grhh='git reset --hard'
# alias grmv='git remote rename'
# alias grrm='git remote remove'
# alias grset='git remote set-url'
# alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
# alias gru='git reset --'
# alias grup='git remote update'
# alias grv='git remote -v'
# 
# alias gsb='git status -sb'
# alias gsd='git svn dcommit'
# alias gsh='git show'
# alias gsi='git submodule init'
# alias gsps='git show --pretty=short --show-signature'
# alias gsr='git svn rebase'
# alias gss='git status -s'
# alias gst='git status'
# alias gsta='git stash save'
# alias gstaa='git stash apply'
# alias gstc='git stash clear'
# alias gstd='git stash drop'
# alias gstl='git stash list'
# alias gstp='git stash pop'
# alias gsts='git stash show --text'
# alias gsu='git submodule update'
# 
# alias gts='git tag -s'
# alias gtv='git tag | sort -V'
# 
# alias gunignore='git update-index --no-assume-unchanged'
# alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
# alias gup='git pull --rebase'
# alias gupv='git pull --rebase -v'
# alias glum='git pull upstream master'
# 
# alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
# alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"'
