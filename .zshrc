# Portable zshrc: Linux (niri/linuxbrew) and macOS (homebrew). Linked by setup.sh.
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt appendhistory
export EDITOR=nvim

# --- package manager / toolchain paths --------------------------------------
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"   # uv
[ -f "$HOME/.cargo/env" ]     && . "$HOME/.cargo/env"
export PATH="$HOME/.local/bin:$PATH"
[ -d /usr/local/lib/python3.12/dist-packages ] && export PATH="${PATH}:/usr/local/lib/python3.12/dist-packages"
[ -d /usr/local/go/bin ] && export PATH=$PATH:/usr/local/go/bin
[ -d "$HOME/go/bin" ]    && export PATH=$PATH:$HOME/go/bin

# pnpm
case "$OSTYPE" in
  darwin*) export PNPM_HOME="$HOME/Library/pnpm" ;;
  *)       export PNPM_HOME="$HOME/.local/share/pnpm" ;;
esac
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# trust dotfiles mise config on every machine (avoids "Config files ... are not trusted")
export MISE_TRUSTED_CONFIG_PATHS="$HOME/dotfiles"
command -v mise >/dev/null && eval "$(mise activate zsh)"

# --- completion ------------------------------------------------------------
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|/=. r:|=*'

# --- aliases / functions ---------------------------------------------------
alias eric='claude'
alias c='claude'
alias cc='claude --continue'
alias sb='source ~/.zshrc'
alias sv='vim ~/.zshrc'
alias sk='make build'
alias cdd='cd ~/dev'
alias icat='kitty +kitten icat'
# Tailscale.app doesn't put its CLI on PATH, and a symlink to it crashes
# ("bundleIdentifier is unknown to the registry"), so alias it instead
[ -x /Applications/Tailscale.app/Contents/MacOS/Tailscale ] &&
  alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'

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

# --- prompt / navigation ---------------------------------------------------
command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide   >/dev/null && eval "$(zoxide init zsh)"

# --- fzf -------------------------------------------------------------------
if command -v fzf >/dev/null; then
  if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then       # debian/ubuntu
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
  else                                                                # brew (mac/linux)
    eval "$(fzf --zsh)"
  fi
  if ! command -v atuin >/dev/null; then   # atuin owns ^R when present
    fzf-and-run-widget() {
      fzf-history-widget
      zle accept-line
    }
    zle     -N   fzf-and-run-widget
    bindkey '^R' fzf-and-run-widget
  fi
fi

# --- atuin: synced shell history (^R search, up-arrow = this session) -------
command -v atuin >/dev/null && eval "$(atuin init zsh)"

# Fix Ctrl+A / Ctrl+E
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# --- local, untracked ------------------------------------------------------
[ -f ~/.zshrc_api ]   && source ~/.zshrc_api
[ -f ~/.zsh_work ]    && source ~/.zsh_work
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
