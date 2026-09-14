HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt appendhistory
export EDITOR=nvim

# Enable completion system
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|/=. r:|=*'


. "$HOME/.local/bin/env"

alias eric='claude'
# emacs profile lives in ~/.config/emacs-profile (doom | spacemacs); GUI/niri use
# the same switch via ~/.local/bin/emacs-launch
emacs() {
  local profile dir sock
  profile=$(cat ~/.config/emacs-profile 2>/dev/null)
  case "${profile:-doom}" in
    doom*) dir=~/doom-emacs; sock=doom ;;
    *)     dir=~/.emacs.d;   sock=spacemacs ;;
  esac
  emacsclient -s "$sock" --eval t >/dev/null 2>&1 ||
    command emacs --daemon="$sock" --init-directory "$dir"
  emacsclient -nw -s "$sock" "$@"
}
alias sb='source /home/hasan/.zshrc'
alias sv='vim /home/hasan/.zshrc'
alias sk='make build'
alias cdd='cd /home/hasan/dev'
alias icat='kitty +kitten icat'

alias cc='claude --continue'
alias c='claude'

# eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
. "$HOME/.cargo/env"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
export PATH=$HOME/.local/bin:$PATH
export PATH="${PATH}:/usr/local/lib/python3.12/dist-packages"

[ -f ~/.zshrc_api ] && source ~/.zshrc_api
[ -f ~/.zsh_work ] && source ~/.zsh_work


# Append this line to ~/.zshrc to enable fzf keybindings for Zsh:
source /usr/share/doc/fzf/examples/key-bindings.zsh
# Append this line to ~/.zshrc to enable fuzzy auto-completion for Zsh:
source /usr/share/doc/fzf/examples/completion.zsh

fzf-and-run-widget() {
  fzf-history-widget
  zle accept-line
}
zle     -N   fzf-and-run-widget
bindkey '^R' fzf-and-run-widget

# Fix Ctrl+A to go to beginning of line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# pnpm
export PNPM_HOME="/home/hasan/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate zsh)"

# >>> Codex installer >>>
export PATH="/home/hasan/.local/bin:$PATH"
# <<< Codex installer <<<

