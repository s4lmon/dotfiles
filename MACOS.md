# Mac setup

Run `bash setup.sh`. The former Mac Spacemacs configuration is saved in
`.spacemacs.macos`; the Linux `.spacemacs` is unchanged. The complete former
Spacemacs installation remains locally at `~/.emacs.d.bak`.

Doom enables the macOS module, uses JuliaMono, and maps Command to Meta and
Option to Super. AeroSpace reserves Option shortcuts. Homebrew installs GUI
Emacs and required command-line tools. Run `~/doom-emacs/bin/doom sync --env` after
changing shell paths so GUI Emacs inherits them.

Atuin is enabled in `.zshrc`; Ctrl-R searches history. On a new machine run
`atuin import zsh`. Account login and the existing encryption key are needed
for cross-machine sync; neither belongs in this repository. Shell history
and Atuin databases must remain private local files.

The Mac Sketchybar config and scripts live in `.config/sketchybar`. Setup
installs Sketchybar and Hack Nerd Font. Workspace app icons also require
`sketchybar-app-font` (already installed on this Mac). AeroSpace starts the
bar and its workspace icon watcher.
