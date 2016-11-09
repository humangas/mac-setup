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
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Alias
alias ls='gls --color=auto'
alias vi='vim'
alias fzf='fzf-tmux'
alias 00='source ~/.zshrc'
alias 0w='cd ~/src/work'
alias 0s='PDIR=$(L=`ghq list -p`; L="$L\n`ls -d $GOPATH/src/work/*`" ; echo -e "$L" | sort | uniq | fzf); cd "$PDIR" > /dev/null 2>&1 || cd $(dirname "$PDIR")' 
alias 0p='actionCurrentResource'

## History
#export HISTFILE=${HOME}/.zsh_history                   # save history file 
## メモリに保存される履歴の件数
#export HISTSIZE=100
## 履歴ファイルに保存される履歴の件数
#export SAVEHIST=100
#
## 重複を記録しない
#setopt hist_ignore_dups
## 開始と終了を記録
#setopt EXTENDED_HISTORY
## 重複を記録しない
#setopt hist_ignore_all_dups
## ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
#setopt hist_ignore_all_dups
## スペースで始まるコマンド行はヒストリリストから削除
#setopt hist_ignore_space
## 余分な空白は詰めて記録
#setopt hist_reduce_blanks  
## 古いコマンドと同じものは無視 
#setopt hist_save_no_dups
## historyコマンドは履歴に登録しない
#setopt hist_no_store

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

