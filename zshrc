#! /usr/bin/env zsh
#
# Made by Vincent Camus
#

system=`uname -s` # Get the current system.

#-------------------------------------------------------------------------------
# Env
#-------------------------------------------------------------------------------

# Personal
export NAME='vincent'
export FULLNAME='Vincent Camus'
export EMAIL='vincent.camus@pulse-ar.com'

# Utilities
# export PAGER='less'
export EDITOR='vim'                     # for svn
export LS_OPTIONS='-b -h --color=auto'
export PAGER='less'

# Path
export PATH="$PATH":/opt/firefox/

#-------------------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------------------

# Mandatory
alias ls="ls $LS_OPTIONS"
alias l="ls"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias mv="mv -v"
alias cp="cp -v"
alias grep="grep --color -H"
alias screen="screen -aAdR"

# Misc
alias mktags="cscope-indexer -r .; ctags -Re ."

#-------------------------------------------------------------------------------
# Options
#-------------------------------------------------------------------------------

setopt correct                  # spelling correction
setopt complete_in_word         # not just at the end
setopt alwaystoend              # when completing within a word, move cursor to the end of the word
setopt auto_cd                  # change to dirs without cd
setopt hist_ignore_all_dups     # If a new command added to the history list duplicates an older one, the older is removed from the list
setopt hist_find_no_dups        # do not display duplicates when searching for history entries
setopt auto_list                # Automatically list choices on an ambiguous completion.
setopt auto_param_keys          # Automatically remove undesirable characters added after auto completions when necessary
setopt auto_param_slash         # Add slashes at the end of auto completed dir names
setopt complete_aliases
#setopt equals                   # If a word begins with an unquoted `=', the remainder of the word is taken as the name of a command.
                                # If a command exists by that name, the word is replaced by the full pathname of the command.
#setopt extended_glob            # activates: ^x         Matches anything except the pattern x.
                                #            x~y        Match anything that matches the pattern x but does not match y.
                                #            x#         Matches zero or more occurrences of the pattern x.
                                #            x##        Matches one or more occurrences of the pattern x.
setopt hash_cmds                # Note the location of each command the first time it is executed in order to avoid search during subsequent invocations
setopt hash_dirs                # Whenever a command name is hashed, hash the directory containing it
#setopt mail_warning             # Print a warning message if a mail file has been accessed since the shell last checked.
setopt append_history           # append history list to the history file (important for multiple parallel zsh sessions!)

# History
HISTFILE=~/.history_zsh
SAVEHIST=142
HISTSIZE=142

#-------------------------------------------------------------------------------
# Prompts
#-------------------------------------------------------------------------------

# Colors
std="%{[m%}"
red="%{[0;31m%}"
green="%{[0;32m%}"
yellow="%{[0;33m%}"
blue="%{[0;34m%}"
purple="%{[0;35m%}"
cyan="%{[0;36m%}"
grey="%{[0;37m%}"
white="%{[0;38m%}"
lred="%{[1;31m%}"
lgreen="%{[1;32m%}"
lyellow="%{[1;33m%}"
lblue="%{[1;34m%}"
lpurple="%{[1;35m%}"
lcyan="%{[1;36m%}"
lgrey="%{[1;37m%}"
lwhite="%{[1;38m%}"

#Prompts
PS2='`%_> '       # secondary prompt, printed when the shell needs more information to complete a command.
PS3='?# '         # selection prompt used within a select loop.
PS4='+%N:%i:%_> ' # the execution trace prompt (setopt xtrace). default: '+%N:%i>'

local prompt_user="${lyellow}%n${std}"
local prompt_host="${lgreen}%m${std}"
if [ $UID -eq 0 ]; then
	prompt_user="${red}%n${std}"
	prompt_host="${red}%m${std}"
fi
local prompt_cwd="%B%40<..<%~%<<%b"
local prompt_time="${lgrey}%D{%H:%M:%S}${std}"
local prompt_rv="%(?..${lred}%?${std} )"
PROMPT="${prompt_user}${white}@${std}${prompt_host} ${prompt_cwd} %(!.#.$) "
RPROMPT="${prompt_rv}${prompt_time}"

#-------------------------------------------------------------------------------
# Key bindings
#-------------------------------------------------------------------------------

bindkey -e
bindkey '\e[1~'	beginning-of-line	# home
bindkey '\e[4~'	end-of-line		# end
bindkey "[3~" delete-char		# del
bindkey "^[[A"	up-line-or-search	# cursor up
bindkey "\eOP"	run-help		# run-help when F1 is pressed
bindkey ' '	magic-space		# also do history expansion on space

#-------------------------------------------------------------------------------
# Completion
#-------------------------------------------------------------------------------

# The following lines were added by compinstall
_compdir=~/usr/share/zsh/functions
[[ -z $fpath[(r)$_compdir] ]] && fpath=($fpath $_compdir)

autoload -U compinit; compinit
#compinit /home/prolob/pollux/.zcompdump # wtf?

# This one is a bit ugly. You may want to use only `*:correct'
# if you also have the `correctword_*' or `approximate_*' keys.
# End of lines added by compinstall

zmodload zsh/complist

zstyle ':completion:*:processes' command 'ps -au$USER'     # on processes completion complete all user processes
zstyle ':completion:*:descriptions' format \
       $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'           # format on completion
zstyle ':completion:*' verbose yes                         # provide verbose completion information
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format \
       $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
zstyle ':completion:*:matches' group 'yes'                 # separate matches into groups
zstyle ':completion:*:options' description 'yes'           # describe options in full
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:*:zcompile:*' ignored-patterns '(*~|*.zwc)'

# activate color-completion(!)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

zstyle ':completion:*'             completer _complete _correct _approximate
zstyle ':completion:*:correct:*'   insert-unambiguous true
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'   original true
zstyle ':completion:correct:'      prompt 'correct to:'

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:' max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# ignore duplicate entries
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# If there are more than N options, allow selecting from a menu with
# arrows (case insensitive completion!).
zstyle ':completion:*' menu select=2

# caching
# [ -d $ZSHDIR/cache ] && zstyle ':completion:*' use-cache yes && \
#                        zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/

#-------------------------------------------------------------------------------
# Misc
#-------------------------------------------------------------------------------
