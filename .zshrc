# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load p10k
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# Load Prezto
# https://github.com/sorin-ionescu/prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
aliases[ls]=lsd

# Ruby Environment
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


# Functions
download() { (cd ~/Downloads && curl -O "$@"); }
findserver() { lsof -sTCP:LISTEN -i"$@"; }
killserver() { kill "${@:2}" $(findserver "$1" -t); }
present() { export PS1='$ '; clear; }

# Yarn
export PATH="$PATH:$(yarn global bin)"

# NVM
export NVM_DIR="$HOME/.nvm"
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# fzf
source /usr/local/opt/fzf/shell/key-bindings.zsh
source /usr/local/opt/fzf/shell/completion.zsh
aliases[fd]='noglob fd --ignore-file ~/.config/fd/ignore'
export FZF_ALT_C_COMMAND="$aliases[fd] -Ht=d"
export FZF_CTRL_T_COMMAND="$aliases[fd] -Hc=always"
export FZF_DEFAULT_COMMAND="$aliases[fd] -Ht=f -c=always"
export FZF_DEFAULT_OPTS='--ansi'
FZF_PREVIEW_COMMAND='bat --style numbers,changes --color always'

# Aliases
alias rstart='redis-server /usr/local/etc/redis.conf'
alias fstart='foreman start -f Procfile.dev -m web=1,webpack-client-bundle=1,webpack-server-bundle=1,vm-renderer=1'
alias batfind="fzf --preview '$FZF_PREVIEW_COMMAND {} | head -500'"
alias fd=$aliases[fd]
alias tree="ls --tree $(sed 's/.*/-I=\\"&\\"/' ~/.config/fd/ignore | xargs)"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Doom Emacs
export PATH=$PATH:~/.emacs.d/bin

# Editor
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"                  # $EDITOR opens in terminal
export VISUAL="emacsclient -c -a emacs"         # $VISUAL opens in GUI mode

# Postgres
export PGHOST=localhost

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

