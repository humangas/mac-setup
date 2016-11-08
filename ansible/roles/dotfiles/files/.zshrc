################################################################################################
# ~/.zshrc
################################################################################################
# Base
autoload -Uz compinit; compinit                        # auto-completion: on
autoload -Uz colors; colors                            # colors: on
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'    # Match to uppercase lowercase conversion
# To enable the completion with sudo command
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   			   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# Prompt
#PROMPT="%U%F{blue}%n%f@%F{cyan}%M%f%u$vcs_info_msg_0_$p_mark "
#RPROMPT="%U%F{cyan}%~%f|%F{blue}%D{%y/%m/%d %H:%M:%S}%f%u"

# Bindkey
bindkey -v                                             # vi keybind 
bindkey "^[[Z" reverse-menu-complete                   # shift-tab reverse

# Env go setting
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

# Env oracle client setting
export ORACLE_HOME=/usr/local/oracle
export TNS_ADMIN=~/.config/oracle
export PATH=$ORACLE_HOME:$PATH
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ORACLE_HOME
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME

# Load 
eval "$(gdircolors ~/.config/solarized/dircolors.256dark)"
eval "$(direnv hook bash)"
eval "$(pyenv init -)" 
eval "$(pyenv virtualenv-init -)"

# Alias
alias ls='gls --color=auto'
alias vi='vim'
alias 0w='cd ~/src/work'
alias 0s='PDIR=$(L=`ghq list -p`; L="$L\n`ls -d $GOPATH/src/work/*`" ; echo -e "$L" | sort | uniq | fzf); cd "$PDIR" > /dev/null 2>&1 || cd $(dirname "$PDIR")' 
alias 0p='actionCurrentResource'

# Plugin zplug
source ~/.zplug/init.zsh

# Plugins...
zplug "b4b4r07/enhancd", use:init.sh
zplug "b4b4r07/zsh-vimode-visual"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

# Functions
function actionCurrentResource() {
  local T=$(ls -dF $PWD/* | fzf)
  echo "cd $T" | grep /$
  if [ "$?" -eq 0 ]; then
    cd "$T"   
  else
    #file "$T" | cut -d: -f2 | [ `cut -d" " -f2` == "ASCII" ]
    local type=$(file "$T" | cut -d: -f2 | cut -d" " -f2)
    if [[ "$type" == 'ASCII' ]] || [[ "$type" == 'Python' ]]; then
      vim "$T"
    else
      read '?Open Finder? [y|n]: ' ans
      if [[ $ans == 'y' ]]; then
        open .
      fi  
    fi
  fi
}

