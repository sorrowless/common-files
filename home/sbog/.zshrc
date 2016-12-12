export EDITOR="vim"

# Use zgen (https://github.com/tarjoilija/zgen.git) to manage plugins for zsh.
# We try to automatically download it if it doesn't exists and also will auto
# apply it for current shell
#
# Export needed variables
ZGEN_GHUB='https://github.com/tarjoilija/zgen.git'
ZGEN_HOME="${HOME}/.zgen"
ZGEN_FILE="${ZGEN_HOME}/zgen.zsh"
RC=1
#
# Check if zgen directory exists, if not - install zgen
if [ ! -d "${ZGEN_HOME}" ]; then
  echo "zgen plugins manager directory ${ZGEN_HOME} not found, try to install zgen"
  type git 1>/dev/null 2>&1
  RC=$?
  if [ "$RC" -ne 0 ]; then
    echo "cannot find git, skip installing zgen"
  else
    git clone ${ZGEN_GHUB} ${ZGEN_HOME}
    RC=$?
    if [ "$RC" -ne 0 ]; then
      echo "cannot clone zgen repository from ${ZGEN_GHUB}, skip installing zgen"
    fi
  fi
else
  RC=0
fi
if [ -f "${ZGEN_FILE}" ] && [ "$RC" -eq 0 ]; then
  #
  # Load zgen
  source "${HOME}/.zgen/zgen.zsh"
  # If the init scipt doesn't exist
  if ! zgen saved; then

    # Plugins list here
    zgen load marzocchi/zsh-notify
    zgen load zsh-users/zsh-syntax-highlighting

    # Generate the init script from plugins above
    zgen save
  fi

  # Settings for zsh-notify plugin
  zstyle ':notify:*' error-title Error
  zstyle ':notify:*' success-title Success
  zstyle ':notify:*' command-complete-timeout 5
  # End settings for zsh-notify plugin
else
  echo "zgen plugins manager main file ${ZGEN_FILE} doesn't exists, skip plugins initialization"
fi
# End zgen plugins manager initialization

autoload zkbd
[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
if [[ ! -f ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE} ]]; then
  zkbd
else
  source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
  #setup key accordingly
  [[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
  [[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
  [[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
  [[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
  [[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
  [[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
  [[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
  [[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
fi

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
# set right prompt side
function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|)/} $(gitbranch) $(battshow)"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
bindkey 'ii' vi-cmd-mode
bindkey ',,' insert-last-word

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
alias scat='openssl x509 -text -noout -in'
alias sc='systemctl'
alias sclu='systemctl list-units'
if command -v colordiff > /dev/null 2>&1; then
    alias diff="colordiff -Nar"
    alias diffy="colordiff -Nar -y --suppress-common-lines"
else
    alias diff="diff -Nar"
    alias diffy="diff -Nar -y --suppress-common-lines"
fi
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias ls='ls --color=auto --human-readable --group-directories-first --classify'
alias feh='feh -x -F -Y'
alias less='less -S'
# you know, that's funny ;)
alias fuck='sudo $(fc -ln -1)'
alias wttr='curl http://wttr.in/'

# Export more specific variables for less
# export LESS='-srSCmqPm--Less--(?eEND:%pb\%.)'

# VirtualenvWrapper
export WORKON_HOME=~/.virtualenvs
if [ -f /usr/bin/virtualenvwrapper.sh ]; then
  source /usr/bin/virtualenvwrapper.sh
else
  echo "virtualenvwrapper script for Python not found, skip load it"
fi
#unset GREP_OPTIONS

# set 256 colors for terminal
export TERM=xterm-256color

# SSH-related funcs
check-ssh-agent() {
  if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    echo "ssh-agent not running, run it"
    eval `ssh-agent`
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
    echo "ran ssh-agent"
  fi
}

check-ssh-add() {
  export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
  if ! ssh-add -l >/dev/null; then
    ssh-add -t 8h
    echo "Keys were added to an agent"
  fi
}

ssh() {
  check-ssh-agent
  check-ssh-add
  /usr/bin/ssh $@
}

# M-b and M-f (backward-word and forward-word) would jump over each word separated by a '/'
export WORDCHARS='*?_[]~=&;!#$%^(){}'
