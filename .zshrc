# nikhil's zshrc
# created 17 June 2009
# --------
# thanks to srobertson's zshrc (http://bitbucket.org/srobertson/rc-files)
# --------

# don't start in /
if [ "`pwd`" = '/' ]; then
    cd
fi

# X11 settings for XMonad
export PATH=/Users/nikhil/.cabal/bin:$PATH
export USERWM=$(which xmonad)

# environment variables
source $HOME/.env

# aliases
source $HOME/.aliases

# The following lines were added by compinstall
zstyle ':completion:*' cache-path ~/.zsh_cache
zstyle ':completion:*' completer _list _complete _ignored _approximate
zstyle ':completion:*' condition 0
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]} r:|[._-]=* r:|=*' 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=3
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-cache on
zstyle ':completion:*' verbose true
zstyle ':completion:*' cache-path ~/.zsh_cache
# Processes
zstyle ':completion:*:processes' command 'ps -axw'
zstyle ':completion:*:processes-names' command 'ps -awxho command'
# My Scripts
zstyle ':completion:*:*:rarstream.py:*' file-patterns \
    '*.rar:rar-files' '%p:all-files'
zstyle ':completion:*:*:play.py:*' file-patterns \
    '*.(avi|mkv|mp4):movie-files' '%p:all-files'

zstyle :compinstall filename '/home/nikhil/.zshrc'
autoload -Uz compinit
compinit

###############
# ZSH OPTIONS #
###############

# Changing Directories
setopt AUTO_PUSHD           # make cd push old directory onto dir stack
setopt PUSHD_IGNORE_DUPS    # don't push multiple copies of the same dir onto the dir stack

# Completion
setopt COMPLETE_ALIASES     # complete aliases before command is run
setopt MENU_COMPLETE        # use menu to select from completions

# Expansion and Globbing
setopt GLOB                 # glob files
setopt MARK_DIRS            # append / to directories when globbing

# History
setopt INC_APPEND_HISTORY   # append to same history file and don't wait for shell exit to write history
setopt EXTENDED_HISTORY     # put timestamps in history
setopt HIST_FIND_NO_DUPS    # don't display duplicates when searching through history in line editor

# Input/Output
setopt HASH_CMDS            # hash commands to avoid lots of PATH searches
setopt HASH_DIRS            # hash dirs containing commands used

# Job Control
unsetopt BG_NICE            # don't nice bg commands
setopt AUTO_CONTINUE        # automatically continue disowned jobs

# Zle (line editor)
unsetopt BEEP               # don't beep
bindkey -v                  # vi bindings
bindkey '^r' history-incremental-search-backward
bindkey '\e[1~' beginning-of-line
bindkey '\e[7~' beginning-of-line
bindkey '\eOH'  beginning-of-line
bindkey '\e[H'  beginning-of-line
bindkey '^A'    beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[8~' end-of-line
bindkey '\eOF'  end-of-line
bindkey '\e[F'  end-of-line
bindkey '^E'    end-of-line
bindkey '\e[3~' delete-char
bindkey '^?'    backward-delete-char

[[ -s "/Users/nikhil/.rvm/scripts/rvm" ]] && source "/Users/nikhil/.rvm/scripts/rvm"  # This loads RVM into a shell session.
# vim:set ft=zsh
