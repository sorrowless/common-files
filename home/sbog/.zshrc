export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

autoload zkbd
[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
[[ ! -f ~/.zkbd/xterm-:0.0 ]] && zkbd
source  ~/.zkbd/xterm-:0.0
#setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# History options
export HISTSIZE=2000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_ignore_space

setopt noflowcontrol
# if you will not set promptsubst then your prompt will be computed only one time
# when it will be set first time
setopt promptsubst

autoload -Uz compinit
compinit

# Actually, I hate default zsh autoselect, so - no select
zstyle ':completion:::*:default' menu no select

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'

#autoload -U promptinit
#promptinit
#prompt adam2 cyan blue cyan black
autoload -U colors && colors

function who_am_i {
    # this function shows who I am and where I'm sitting now
    # %n is $USERNAME variable. %m is The hostname up to the first ‘.’
    echo "%{$fg[magenta]%}%n%{$reset_color%} %{$fg[white]%}at%{$reset_color%} %{$fg[yellow]%}%m%{$reset_color%}"
}

function happy_sad {
    # next line is just ternary operator in zsh. It shows ^_^ if last command was true
    # and o_O if it was false
    echo "%(?.%{$fg[green]%}^_^%{$reset_color%}.%{$fg[red]%}o_O%{$reset_color%})"
}

function battshow {
    # shows how many battery remains in percentage
    local ret="$(acpi 2>/dev/null)"
    [ $ret ] || return
    local percent="$(echo $ret | awk '{ print $4}')"
    if echo $ret | grep -q "Discharging"
    then
      echo "%{$fg[white]%}battery%{$reset_color%} ▾$percent%%"
    else
      echo "%{$fg[white]%}battery%{$reset_color%} ▴$percent%%"
    fi
}

function gitbranch {
    # find current git branch
    local ret="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    # and test that it is not null. If not null - then print it.
    [ $ret ] && echo "%{$fg[white]%}on git branch%{$reset_color%} [%{$fg[red]%}$ret%{$reset_color%}]%{$fg[white]%},%{$reset_color%}"
}
# it MUST be in singlequotes. Otherwise, promptsubst will not be working
PROMPT='
$(who_am_i) %{$fg[white]%}in%{$reset_color%} %{$fg_no_bold[cyan]%}%d%{$reset_color%}
$(happy_sad) -> '
RPS1='$(gitbranch) $(battshow)'

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias cp='cp -iv'
alias rcp='rsync -v --progress'
alias rmv='rsync -v --progress --remove-source-files'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'
alias ln='ln -v'
alias chmod="chmod -c"
alias chown="chown -c"
alias ip='ip -4 -o'
alias du='du -hc'
alias df='df -h'
alias svim='sudo vim'
if command -v colordiff > /dev/null 2>&1; then
    alias diff="colordiff -Nuar"
else
    alias diff="diff -Nuar"
fi
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias ls='ls --color=auto --human-readable --group-directories-first --classify'
alias feh='feh -x -F -Y'

# VirtualenvWrapper
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh
#unset GREP_OPTIONS
