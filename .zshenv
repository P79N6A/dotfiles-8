export LANG='en_US.UTF-8'
export LC_CTYPE=$LANG
export PATH=/usr/local/sbin:/usr/local/bin:$HOME/Library/Python/2.7/bin:$PATH:$HOME/bin
export EDITOR=/usr/local/bin/vim
export VISUAL=$EDITOR

# color
export CLICOLOR=1
export LSCOLORS='exfxcxdxbxGxDxabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS'

# icloud drive
export icloud=~/Library/Mobile\ Documents/com\~apple\~CloudDocs

# zplug
export ZPLUG_HOME=/usr/local/opt/zplug

# pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# go
eval "$(goenv init -)"
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/go/bin:$GOROOT/bin

# rust
export PATH=$PATH:$HOME/.cargo/bin

# brew
export HOMEBREW_AUTO_UPDATE_SECS=86400

# xapian cjk tokenizer
export XAPIAN_CJK_NGRAM=1

# vim:ft=zsh
