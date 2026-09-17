#!/usr/bin/env bash
# Bootstrap. idempotent

set -euo pipefail

DOTFILES=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOOM_DIR=${DOOM_DIR:-$HOME/doom-emacs}
OS=${DOTFILES_OS:-$(uname -s)}

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }

link() {
  local src=$DOTFILES/$1 dst=${2:-$HOME/$1}
  [ -e "$src" ] || { warn "missing in repo: $1"; return 0; }
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    [ "$(readlink "$dst")" = "$src" ] && return 0
    rm "$dst"
  elif [ -e "$dst" ]; then
    warn "moving existing $dst to $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -s "$src" "$dst"
  log "linked $dst"
}

# ---------------------------------------------------------------------------
# Packages
# ---------------------------------------------------------------------------
install_pkgs_macos() {
  if ! command -v brew >/dev/null; then
    warn "Homebrew not found; install it from https://brew.sh and re-run"
    return 0
  fi
  local formulas=(
    gh ripgrep fd coreutils
    cmake libtool
    aspell shellcheck shfmt pandoc
    node
    tmux starship fzf zoxide atuin uv
    felixkratz/formulae/borders
  )
  local casks=(
    emacs
    font-juliamono font-symbols-only-nerd-font
    nikitabobko/tap/aerospace
  )
  [ -d /Applications/kitty.app ] || casks+=(kitty)

  brew tap nikitabobko/tap >/dev/null
  brew tap felixkratz/formulae >/dev/null

  local missing=()
  for f in "${formulas[@]}"; do
    brew list --formula "${f##*/}" >/dev/null 2>&1 || missing+=("$f")
  done
  [ ${#missing[@]} -eq 0 ] || { log "brew install ${missing[*]}"; brew install "${missing[@]}"; }

  missing=()
  for c in "${casks[@]}"; do
    brew list --cask "${c##*/}" >/dev/null 2>&1 || missing+=("$c")
  done
  [ ${#missing[@]} -eq 0 ] || { log "brew install --cask ${missing[*]}"; brew install --cask "${missing[@]}"; }

  local bin
  bin=$(brew --prefix)/bin
  if ! command -v kitty >/dev/null && [ -x /Applications/kitty.app/Contents/MacOS/kitty ]; then
    ln -sfn /Applications/kitty.app/Contents/MacOS/kitty "$bin/kitty"
    ln -sfn /Applications/kitty.app/Contents/MacOS/kitten "$bin/kitten"
    log "linked kitty and kitten into $bin"
  fi
}

install_pkgs_linux() {
  local needed=(emacs git rg fd cmake aspell tmux starship fzf zoxide atuin kitty)
  local missing=()
  for t in "${needed[@]}"; do command -v "$t" >/dev/null || missing+=("$t"); done
  [ ${#missing[@]} -eq 0 ] || warn "not on PATH: ${missing[*]} (install with your package manager)"
  fc-list 2>/dev/null | grep -qi juliamono || warn "JuliaMono font not installed"
}

# ---------------------------------------------------------------------------
# Symlinks
# ---------------------------------------------------------------------------
link_common() {
  link .doom.d
  link .tmux.conf
  link .config/kitty
  link .config/tmux
  link .config/starship.toml
  link .config/emacs-profile
  link .local/bin/emacs-launch
  link .local/bin/sun-theme
  link .zshrc
  link .gitconfig
  link .config/atuin/config.toml
}

link_macos() {
  link .config/aerospace
  link .config/borders
  link_launch_agent com.hasan.sun-theme
}

# Symlink a plist from .config/launchd into ~/Library/LaunchAgents and (re)load it.
link_launch_agent() {
  local label=$1 dst="$HOME/Library/LaunchAgents/$1.plist"
  link ".config/launchd/$1.plist" "$dst"
  launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
  if launchctl bootstrap "gui/$(id -u)" "$dst"; then log "loaded launch agent $label"; else warn "could not load $label"; fi
}

link_tree() {
  local f
  while IFS= read -r f; do
    link "${f#"$DOTFILES"/}"
  done < <(find "$DOTFILES/$1" -type f)
}

link_linux() {
  link .spacemacs
  for d in niri mako swaylock fontconfig fuzzel nvim mise DankMaterialShell rog Code systemd; do
    link_tree ".config/$d"
  done
  link_tree .local/bin
}

# ---------------------------------------------------------------------------
# Doom Emacs
# ---------------------------------------------------------------------------
setup_doom() {
  command -v emacs >/dev/null || { warn "emacs not on PATH; skipping Doom"; return 0; }
  if [ ! -d "$DOOM_DIR" ]; then
    log "cloning Doom Emacs into $DOOM_DIR"
    git clone --depth 1 https://github.com/doomemacs/doomemacs "$DOOM_DIR"
  fi
  link_dir_to_doom() {
    local dst=$1
    if [ -L "$dst" ]; then
      [ "$(readlink "$dst")" = "$DOOM_DIR" ] && return 0
      rm "$dst"
    elif [ -d "$dst" ]; then
      warn "moving existing $dst to $dst.bak"
      mv "$dst" "$dst.bak"
    fi
    ln -s "$DOOM_DIR" "$dst"
    log "linked $dst -> $DOOM_DIR"
  }
  link_dir_to_doom "$HOME/.emacs.d"
  link_dir_to_doom "$HOME/.config/emacs"

  if [ -d "$DOOM_DIR/.local" ]; then
    log "doom sync"
    "$DOOM_DIR/bin/doom" sync
  else
    log "doom install"
    "$DOOM_DIR/bin/doom" install --force --no-env
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
  log "dotfiles: $DOTFILES ($OS)"
  case $OS in
    Darwin)
      [ -n "${SKIP_PKGS:-}" ] || install_pkgs_macos
      link_common
      link_macos
      ;;
    Linux)
      [ -n "${SKIP_PKGS:-}" ] || install_pkgs_linux
      link_common
      link_linux
      ;;
    *) warn "unsupported OS: $OS"; exit 1 ;;
  esac
  [ -n "${SKIP_DOOM:-}" ] || setup_doom
  log "done"
}

main "$@"
