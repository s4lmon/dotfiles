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

Setup starts a named `doom` daemon through `com.hasan.doom` at login.
Terminal `emacs` and `~/.local/bin/emacs-launch` use emacsclient with that
same daemon. Option-Shift-E opens a GUI client; Option-E toggles layouts.
The `com.hasan.sun-theme` agent updates terminal and prompt colours every
30 minutes. Kitty uses 13pt JuliaMono on macOS, with Symbols Nerd Font Mono
for icon glyphs; the shared Linux font size remains 11pt.

Verified on Emacs 31.1 (native Cocoa/NS, Apple Silicon): AeroSpace reports
`AXWindow` / `AXStandardWindow` for emacsclient frames. The custom theme
loads the built-in `color` library explicitly; Borders updates run
asynchronously so they cannot block the Emacs daemon.
