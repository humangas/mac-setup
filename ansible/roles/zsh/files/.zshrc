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
stty stop undef                                        # disable <C-s>: Stop screen output. 
stty start undef                                       # disable <C-q>: Restart screen output that is stopped.

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

# Load 
eval "$(direnv hook bash)"
eval "$(pyenv init -)" 
eval "$(pyenv virtualenv-init -)"

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

# Alias
alias ls='gls --color=auto'
alias vi='vim'
alias fzf='fzf-tmux'                                                        # fzf: /usr/local/Cellar/fzf/0.15.8/bin/fzf
alias soz='source ~/.zshrc'
alias cap='pygmentize -O style=solarizedlight -f console256 -g'
alias opn='openFileDispatcher'
alias mdf='mdfindFilterFzf'
alias ggr='gitGrepOpenVim'
alias jn='jupyter notebook --notebook-dir ~/src/work/jupyter'               # Required: $ pip insall jupyter
alias gp='open https://play.golang.org/'
alias tmu='tmux resize-pane -U 5'
alias tmd='tmux resize-pane -D 5'
alias tml='tmux resize-pane -L 5'
alias tmr='tmux resize-pane -R 5'
alias rmzcompdump='rm -f ~/.zcompdump; rm -f ~/.zplug/zcompdump'            # If tab completion error occurs, delete it. Then reload the zsh.

alias opd='_openFile $(find . -type d | cut -d. -f2- | egrep -v "\.git/|\.git$|\.DS_Store" | cut -d/ -f2- | fzf -0 --inline-info --cycle --preview "ls -la {}")'
alias cdz='cdCurrentDirs'

# Functions
function _openFile() {
    setopt nonomatch
    if pyenv local  > /dev/null 2>&1; then
        pyenv shell $(pyenv local) 
    fi
    setopt nomatch

    local target="$1"
    [[ -z $target ]] && return 1

    local basedir="${2:-$PWD}/"
    basedir=$(echo $basedir | sed -e 's@/\{2,\}@/@g')
    local filepath="$basedir$target"

    local type=$(file "$filepath" | cut -d: -f2 | grep 'text')
    [[ -z $type ]] && return 1
        if [[ ${#type} -ne 0 ]]; then
        vim "$filepath"
    else
        open "$filepath"
    fi
}

function mdfindFilterFzf(){
    if [[ $# -eq 0 ]]; then
        mdfind
        return $?
    fi

    local T="$(mdfind $@ | fzf)"
    if [[ -d $T ]]; then
        cd "$T"
        cdCurrentDirs
        return $?
    fi
    _openFile "$T"
}

function cdCurrentDirs() {
    readonly EXIT='exit'
    readonly QUIT='quit'

    setopt nonomatch
    if ! ls -df "$PWD"/* > /dev/null 2>&1; then
        return 0
    fi
    setopt nomatch

    local T=$(ls -dF $PWD/* | grep /$)
    if [[ ! -z $T ]]; then
        T="$T\n$EXIT\n$QUIT"
        local target=$(echo $T | fzf)
        [[ $target == $EXIT || $target == $QUIT ]] && return 0
        cd "$target"
        cdCurrentDirs 
    fi
}

function openCurrentGitURL() {
    local url=$(git config -l | grep remote.origin.url | cut -d= -f2)

    if [[ ! -n $url ]]; then
        echo "Error! git remote.origin.url not found"
        return 1
    fi
  
    if [[ -n $(echo $url | grep 'http') ]]; then
        open "$url"
    elif [[ -n $(echo $url | grep 'ssh') ]]; then
        url=$(echo "$url" | sed "s/ssh:/https:/" | sed "s/git@//")
        open "$url"
    elif [[ -n $(echo $url | grep 'git') ]]; then
        url=$(echo "$url" | sed "s/:/\//" | sed "s/git@/https:\/\//")
        open "$url"
    else
        echo "Error! Unexpected form: $url" 
        return 1
    fi
}

function openFileFromDstDir() {
    local dstdir=${1:-$PWD}

    if [[ ! -e $dstdir ]]; then
        echo "Error $dstdir is not found."
        return 1
    fi

    pyenv shell system

    if [[ $dstdir == $PWD ]]; then
        _openFile $(find $dstdir -type f \
            | sed -e "s@$dstdir/@@" \
            | egrep -v "\.git/|\.git$|\.DS_Store" \
            | fzf -0 --inline-info --cycle --preview "pygmentize -O style=solarizedlight -f console256 -g {}")
    else
        _openFile $(find $dstdir -type f \
            | sed -e "s@$dstdir/@@" \
            | egrep -v "\.git/|\.git$|\.DS_Store" \
            | fzf -0 --inline-info --cycle --preview "pygmentize -O style=solarizedlight -f console256 -g $dstdir/{}") "$dstdir"
    fi
}

function cdGhqDir(){
    pyenv shell system

    local ghqlist=`ghq list`
    local worklist=$(ls -d $GOPATH/src/work/* | sed -e "s@$GOPATH/src/@@")
    local alllist="$ghqlist\n$worklist"
    local mvdir=$(echo -e "$alllist" | sort | uniq \
            | fzf -0 --inline-info --ansi --cycle --preview "ls -la $GOPATH/src/{}")

    [[ -z $mvdir ]] && return 1
    cd "$GOPATH/src/$mvdir"

    setopt nonomatch
    if pyenv local  > /dev/null 2>&1; then
        pyenv shell $(pyenv local) 
    fi
    setopt nomatch
}

# TODO: Implement the following TODO comment
# TODO: Change to directory mode at the press ctrl+d and press tab key move to nested directory.
function openFileDispatcher() {
    case $1 in
        ']' ) cdGhqDir ;; 
        '[' ) cdGhqDir && openFileFromDstDir ;;
        '-' ) echo "TODO: open most recentlly file" ;;
        '@' ) openCurrentGitURL ;;
        '-h') openFileDispatcherUsage  ;;
        *   ) openFileFromDstDir "$1" ;;
    esac
}

function openFileDispatcherUsage() {
echo '
Usage: opn [option|{path}]
    opn is utility tool to easily open files and directories. (use: fzf)
    
    default:  Open files selection screen under the current direcory
    
    option:
        ..    Open parent dir files selection screen
        ]     Open direcotry selection screen in $GOPATH/src 
        [     Open same "]" option, After cd select dir, open current files selection screen
        -     Open most recently files selection screen
        @     Open current git.remote.url in browser
    {path}    Open files selection screen under the {path} directory 
        -h    Show Usage (This is)

'
}

function gitGrepOpenVim() {
    local search="$@"
    if [[ $# -eq 0 ]]; then
        printf "grep string?: "
        read -t 10 search
        [[ -z $search ]] && return 1
    fi

    local select=$(git grep -n $search | fzf)
    [[ -z $select ]] && return 1
    local file=$(echo $select | cut -d: -f1)
    local line=$(echo $select | cut -d: -f2)
    vim -c $line $file
}

# Command less
################################################################################################
# TODO: write manual  
# $ less -M               TODO 
################################################################################################
export LESS='-iMR'
export LESSOPEN='|pygmentize -O style=solarizedlight -f console256 -g %s'

# Load fzf (see also: ~/.cache/dein/repos/github.com/junegunn/fzf/shell/key-bindings.zsh)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='-0 --inline-info --cycle' 

# Source ~/.zsh.d/*.sh
setopt nonomatch
if ls ~/.zsh.d/*.sh > /dev/null 2>&1; then
  for file in ~/.zsh.d/*.sh ; do
    [[ -r $file ]] && source "$file"
  done
fi
setopt nomatch
