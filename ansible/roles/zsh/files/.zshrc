################################################################################################
# ~/.zshrc
# $ bindkey -L       :Examine key binding
# $ man zsh          :List of zsh manuals and zsh overview
# $ man zshmisc      :Script syntax, how to write redirects and pipes, list of special functions, etc. 
# $ man zshexpn      :Notation of glob and variable expansion 
# $ man zshparam     :List of special variables and notation of suffix expansion of variables  
# $ man zshoptions   :List of options that can be set with setopt  
# $ man zshbuiltins  :List of built-in commands 
################################################################################################
# Bindkey
bindkey -v                                             # vi keybind 
bindkey "^[[Z" reverse-menu-complete                   # shift-tab reverse

# Base
autoload -Uz compinit; compinit                        # auto-completion: on
autoload -Uz colors; colors                            # colors: on
setopt no_tify                                         # Notify as soon as the background job is over.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'    # Match to uppercase lowercase conversion (However, distinguish when inputting capital letters)
zstyle ':completion:*:default' menu select=1           # Press <Tab>, you can select the path name from candidates. 
# To enable the completion with sudo command
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                                           /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# Prompt
PROMPT="%U%F{blue}%n%f@%F{cyan}%m:%(5~,%-2~/.../%2~,%~)%f%u"
RPROMPT="%U%F{blue}%D{%Y/%m/%d %H:%M:%S}%f%u"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true        # Enable %c,%u formatting. If there are uncommitted files in the repository, the string is stored.
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"       # only git add files
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"        # not git add files
zstyle ':vcs_info:*' formats "%F{green}%c%u(%b)%f"     # set $vcs_info_msg_0_
zstyle ':vcs_info:*' actionformats '(%b|%a)'           # This format is displayed at merge conflict.
precmd () { vcs_info }
PROMPT=$PROMPT'${vcs_info_msg_0_}$ '

# Env go setting
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

# Env oracle client setting
export ORACLE_HOME=/usr/local/oracle
export TNS_ADMIN=~/.config/oracle
export PATH=$ORACLE_HOME:$PATH
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ORACLE_HOME
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME

# Color
eval "$(gdircolors ~/.config/solarized/dircolors.256dark)"
alias ls='gls --color=auto'

# Load 
eval "$(direnv hook bash)"
eval "$(pyenv init -)" 
eval "$(pyenv virtualenv-init -)"

# Alias
alias vi='vim'
alias fzf='fzf-tmux'
alias soz='source ~/.zshrc'
alias cdw='cd ~/src/work'
alias cds='PDIR=$(L=`ghq list -p`; L="$L\n`ls -d $GOPATH/src/work/*`" ; echo -e "$L" | sort | uniq | fzf); cd "$PDIR" > /dev/null 2>&1 || cd $(dirname "$PDIR")' 
alias cdd='cdCurrentDirs'
alias opf='openCurrentFile'
alias opg='openCurrentGitURL'
alias mdf='mdfindFilterFzf'

# History
################################################################################################
# history command same as $ fc -l
# $ history -i            Show execution date and time
# $ history -D            Show the time spent executing
# $ history <fr> <to>     Specify the range and show it
#   e.g. history 1 5      Show from 1st to 5th 
#   e.g. history -5       Show the last 5 
#   e.g. history 1        Show from 1st (= show all) 
#   e.g. history -10 -5   Show from the tenth most recent to the last five most recent history 
################################################################################################
setopt share_history                             # Share history
export HISTFILE=~/.zsh_history                   # Save history file 
export HISTSIZE=10000                            # Number of history items to store in memory
export SAVEHIST=10000                            # Number of records to be saved in history file
setopt hist_ignore_all_dups                      # Duplicate commands delete the old one
setopt hist_ignore_space                         # Beginning starts with a space, do not add it to history.
setopt hist_no_store                             # Do not register the history command in the history.

# Plugin zplug
source ~/.zplug/init.zsh
## Plugins...
zplug "b4b4r07/enhancd", use:init.sh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"

## Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
## Then, source plugins and add commands to $PATH
zplug load --verbose

# Functions
function _openFile() {
  local T="$1"
  local type=$(file "$T" | cut -d: -f2 | grep 'text')
  if [[ ${#type} -ne 0 ]]; then
    vim "$T"
  else
    read '?Open Finder? [y|n]: ' ans
    if [[ $ans == 'y' ]]; then
      open $(dirname $T)
    fi  
  fi
}

function openCurrentFile() {
  _openFile "$(fzf)"
 }

function mdfindFilterFzf(){
  if [[ $# -eq 0 ]]; then
    mdfind
    return
  fi

  local T="$(mdfind $@ | fzf)"
  if [[ -d $T ]]; then
    cd "$T"
    cdCurrentDirs
    return
  fi
  _openFile "$T"
}

function cdCurrentDirs() {
  readonly EXIT='exit'

  setopt nonomatch
  if ! ls -df "$PWD"/* > /dev/null 2>&1; then
    return
  fi
  setopt nomatch

  local T=$(ls -dF $PWD/* | grep /$)
  if [[ ! -z $T ]]; then
    T="$T\n$EXIT"
    local target=$(echo $T | fzf)
    [[ $target == $EXIT ]] && return
    cd "$target"
    cdCurrentDirs 
  fi
}

function openCurrentGitURL() {
  local url=$(git config -l | grep remote.origin.url | cut -d= -f2 | sed "s/:/\//" | sed "s/git@/https:\/\//")
  if [[ -n $url ]]; then
    open $url
  else
    echo "Error! git remote.origin.url not found"
    return 1
  fi
}

# Load fzf (see also: ~/.cache/dein/repos/github.com/junegunn/fzf/shell/key-bindings.zsh)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source ~/.zsh.d/*.sh
setopt nonomatch
if ls ~/.zsh.d/*.sh > /dev/null 2>&1; then
  for file in ~/.zsh.d/*.sh ; do
    [[ -r $file ]] && source "$file"
  done
fi
setopt nomatch
