################################################################################################
# ~/.zshrc
################################################################################################
autoload -Uz compinit; compinit                        # auto-completion: on
autoload -Uz colors; colors                            # colors: on
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'    # Match to uppercase lowercase conversion
# To enable the completion with sudo command
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   			   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

## bindkey
bindkey -v                                             # vi keybind 
bindkey "^[[Z" reverse-menu-complete                   # shift-tab reverse

## alias
#eval "$(gdircolors ~/.dircolors.ansi-dark.solarized)"
#alias ls='gls --color=auto'

