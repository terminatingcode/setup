#!/bin/bash
# shellcheck disable=SC1090,SC1091

export PATH="/usr/local/bin:$PATH"

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
export BASH_IT_THEME="minimal"
export THEME_SHOW_CLOCK_CHAR="false"

# Load Bash It
source "$BASH_IT/bash_it.sh"

# Configure history
shopt -s histappend  # Append to .bash_history file rather than overwriting

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# eval local ruby version
export PATH="$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init -)"

# Set my editor and git editor
export EDITOR="nvim"
export GIT_EDITOR="nvim"

export LPASS_AGENT_TIMEOUT=32400  # lpass agent will logout 9 hours after logging in

if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# jump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . "$(brew --prefix)/etc/profile.d/autojump.sh"

# direnv
eval "$(direnv hook bash)"

