;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. "~/.mycontribs/")
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(html
     csv
     rust
     go
     typescript
     protobuf
     javascript
     toml
     (python :variables
             python-backend 'lsp
             python-lsp-server 'pyright
             )
     (shell :variables
            shell-default-shell 'vterm)
     go
     yaml
     themes-megapack
     docker
     better-defaults
     emacs-lisp
     git
     helm
     (claude-code :variables
                  claude-code-ide-window-side 'right
                  claude-code-ide-window-width 100)

     (c-c++ :variables
            c-c++-backend 'lsp-clangd
            c-c++-enable-clang-support t
            c-c++-enable-clang-format-on-save t
            )
     lsp
     (cmake :variables
            cmake-backend 'lsp)
     markdown
     multiple-cursors
     org
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     auto-completion
     spell-checking
     syntax-checking
     version-control
     (treemacs :variables
               treemacs-use-follow-mode t
               treemacs-use-filewatch-mode t
               treemacs-use-git-mode 'deferred
               )
     multiple-cursors
     )


   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(consult dumb-jump mpv)

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; Scale factor controls the scaling (size) of the startup banner. Default
   ;; value is `auto' for scaling the logo automatically to fit all buffer
   ;; contents, to a maximum of the full image height and a minimum of 3 line
   ;; heights. If set to a number (int or float) it is used as a constant
   ;; scaling factor for the default logo size.
   dotspacemacs-startup-banner-scale 'auto

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   ;; The exceptional case is `recents-by-project', where list-type must be a
   ;; pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
   ;; number is the project limit and the second the limit on the recent files
   ;; within a project.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Show numbers before the startup list lines. (default t)
   dotspacemacs-show-startup-list-numbers t

   ;; The minimum delay in seconds between number key presses. (default 0.4)
   dotspacemacs-startup-buffer-multi-digit-delay 0.4

   ;; If non-nil, show file icons for entries and headings on Spacemacs home buffer.
   ;; This has no effect in terminal or if "nerd-icons" package or the font
   ;; is not installed. (default nil)
   dotspacemacs-startup-buffer-show-icons nil

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent nil

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable nil

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light). A theme from external
   ;; package can be defined with `:package', or a theme can be defined with
   ;; `:location' to download the theme package, refer the themes section in
   ;; DOCUMENTATION.org for the full theme specifications.
   dotspacemacs-themes '((doom-laserwave :package doom-themes)
                         white-sand
                         spacemacs-light
                         spacemacs-dark)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts. This setting has no effect when
   ;; running Emacs in terminal. The font set here will be used for default and
   ;; fixed-pitch faces. The `:size' can be specified as
   ;; a non-negative integer (pixel size), or a floating-point (point size).
   ;; Point size is recommended, because it's device independent. (default 10.0)
   dotspacemacs-default-font '("DM Mono"
                               :size 12.0
                               :weight normal
                               :width normal)

   ;; Default icons font, it can be `all-the-icons' or `nerd-icons'.
   dotspacemacs-default-icons-font 'all-the-icons

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "M-<return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "M-<return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; It is also possible to use a posframe with the following cons cell
   ;; `(posframe . position)' where position can be one of `center',
   ;; `top-center', `bottom-center', `top-left-corner', `top-right-corner',
   ;; `top-right-corner', `bottom-left-corner' or `bottom-right-corner'
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; Whether side windows (such as those created by treemacs or neotree)
   ;; are kept or minimized by `spacemacs/toggle-maximize-window' (SPC w m).
   ;; (default t)
   dotspacemacs-maximize-window-keep-side-windows t

   ;; If nil, no load-hints enabled. If t, enable the `load-hints' which will
   ;; put the most likely path on the top of `load-path' to reduce walking
   ;; through the whole `load-path'. It's an experimental feature to speedup
   ;; Spacemacs on Windows. Refer the FAQ.org "load-hints" session for details.
   dotspacemacs-enable-load-hints nil

   ;; If t, enable the `package-quickstart' feature to avoid full package
   ;; loading, otherwise no `package-quickstart' attemption (default nil).
   ;; Refer the FAQ.org "package-quickstart" section for details.
   dotspacemacs-enable-package-quickstart nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default t) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup t

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' to obtain fullscreen
   ;; without external boxes. Also disables the internal border. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes the
   ;; transparency level of a frame background when it's active or selected. Transparency
   ;; can be toggled through `toggle-background-transparency'. (default 90)
   dotspacemacs-background-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Show the scroll bar while scrolling. The auto hide time can be configured
   ;; by setting this variable to a number. (default t)
   dotspacemacs-scroll-bar-while-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but only visual lines are counted. For example, folded lines will not be
   ;; counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil', `origami' and `vimish'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil and `dotspacemacs-activate-smartparens-mode' is also non-nil,
   ;; `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil smartparens-mode will be enabled in programming modes.
   ;; (default t)
   dotspacemacs-activate-smartparens-mode t

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "ack" "grep")

   ;; The backend used for undo/redo functionality. Possible values are
   ;; `undo-fu', `undo-redo' and `undo-tree' see also `evil-undo-system'.
   ;; Note that saved undo history does not get transferred when changing
   ;; your undo system. The default is currently `undo-fu' as `undo-tree'
   ;; is not maintained anymore and `undo-redo' is very basic."
   dotspacemacs-undo-system 'undo-fu

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; If nil then Spacemacs uses default `frame-title-format' to avoid
   ;; performance issues, instead of calculating the frame title by
   ;; `spacemacs/title-prepare' all the time.
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Color highlight trailing whitespace in all prog-mode and text-mode derived
   ;; modes such as c++-mode, python-mode, emacs-lisp, html-mode, rst-mode etc.
   ;; (default t)
   dotspacemacs-show-trailing-whitespace t

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; The variable `global-spacemacs-whitespace-cleanup-modes' controls
   ;; which major modes have whitespace cleanup enabled or disabled
   ;; by default.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; If non-nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfere with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Accept SPC as y for prompts if non-nil. (default nil)
   dotspacemacs-use-SPC-as-y nil

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non-nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source nil

   ;; If non-nil then byte-compile some of Spacemacs files.
   dotspacemacs-byte-compile nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env)
  )

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  (setq doom-themes-padded-modeline t)
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  (with-eval-after-load 'forge
    (add-to-list 'forge-alist
                 '("gitlab.werewolf-banded.ts.net"
                   "gitlab.werewolf-banded.ts.net/api/v4"
                   "gitlab.werewolf-banded.ts.net"
                   forge-gitlab-repository)))

  ;; RET / click in magit diffs always visit the editable worktree file,
  ;; never the read-only .~{index}~ / .~HEAD~ blob
  (with-eval-after-load 'magit
    (define-key magit-file-section-map (kbd "RET") #'magit-diff-visit-worktree-file)
    (define-key magit-hunk-section-map (kbd "RET") #'magit-diff-visit-worktree-file)
    (define-key magit-file-section-map [remap magit-visit-thing] #'magit-diff-visit-worktree-file)
    (define-key magit-hunk-section-map [remap magit-visit-thing] #'magit-diff-visit-worktree-file))

  ;; explicit CDN URL: Ubuntu's pandoc defaults --katex to a local path that
  ;; may not exist and that snap-packaged Firefox cannot read anyway
  (setq markdown-command "pandoc -f gfm -t html5 --katex=https://cdn.jsdelivr.net/npm/katex@0.16/dist/ -s")
  ;; snap-packaged Firefox cannot read /tmp, so browser previews must live in $HOME
  (setq browse-url-temp-dir (expand-file-name "~/tmp"))

  (scroll-bar-mode -1)
  (global-company-mode t)
  (global-display-line-numbers-mode t)
  ;; (global-set-key (kbd "C-.") 'company-complete)
  (setq company-idle-delay 0.2) ;; Time in seconds to wait before showing the popup

  ;; --- performance ---
  ;; degrade gracefully on long/minified lines instead of choking the renderer
  (global-so-long-mode 1)
  ;; bidi reordering is pure overhead for LTR source code
  (setq-default bidi-display-reordering 'left-to-right
                bidi-paragraph-direction 'left-to-right)
  (setq bidi-inhibit-bpa t)
  ;; cheaper scrolling: don't refontify mid-scroll, keep point off the edges
  (setq fast-but-imprecise-scrolling t
        redisplay-skip-fontification-on-input t
        scroll-conservatively 101
        scroll-margin 3)
  ;; cap helm-ag/rg output so a broad query doesn't render 49k candidates
  (with-eval-after-load 'helm-ag
    (setq helm-ag-base-command
          "rg --no-heading --color=never --line-number --smart-case --max-columns=200"))
  (setq helm-candidate-number-limit 500)

  (setq projectile-enable-caching t)
  (setq projectile-globally-ignored-file-suffixes '(".whl" ".log" ".txt"))
  (setq projectile-globally-ignored-files '("*[0-9][0-9][0-9][0-9][0-9]*"))

  ;; smerge-mode toggle and navigation
  (defvar smerge-original-bindings nil
    "Store original keybindings to restore when exiting smerge-mode.")

  (defun smerge-mode-toggle ()
    "Toggle smerge-mode and set up local keybindings."
    (interactive)
    (require 'smerge-mode)
    (if (bound-and-true-p smerge-mode)
        (progn
          ;; Restore original keybindings
          (when smerge-original-bindings
            (dolist (binding smerge-original-bindings)
              (evil-local-set-key 'normal (kbd (car binding)) (cdr binding)))
            (setq smerge-original-bindings nil))
          (smerge-mode -1)
          (message "smerge-mode disabled"))
      (progn
        ;; Store original keybindings
        (setq smerge-original-bindings
              (list (cons "j" (lookup-key evil-normal-state-local-map (kbd "j")))
                    (cons "k" (lookup-key evil-normal-state-local-map (kbd "k")))
                    (cons "l" (lookup-key evil-normal-state-local-map (kbd "l")))
                    (cons "u" (lookup-key evil-normal-state-local-map (kbd "u")))))
        (smerge-mode 1)
        (message "smerge-mode enabled - use SPC g g s to exit")
        ;; Set local keybindings when smerge-mode is active
        (evil-local-set-key 'normal (kbd "j") 'smerge-next)
        (evil-local-set-key 'normal (kbd "k") 'smerge-prev)
        (evil-local-set-key 'normal (kbd "l") 'smerge-keep-lower)
        (evil-local-set-key 'normal (kbd "u") 'smerge-keep-upper))))

  (spacemacs/set-leader-keys "ggs" 'smerge-mode-toggle)


  (defun my-project-root (file)
    "Find the project root from FILE by locating .git and .pre-commit-config.yaml."
    (when-let ((git-root (locate-dominating-file file ".git")))
      (when (file-exists-p (expand-file-name ".pre-commit-config.yaml" git-root))
        git-root)))

  ;; --- uv workspace venv auto-activation ---
  ;; uv puts a single .venv at the workspace root; nested workspace members
  ;; (e.g. nucleus, antimatter/mosaic/services/*) import each other via editable
  ;; .pth files in that venv. Activating the nearest .venv before LSP starts
  ;; lets pyright resolve cross-package imports like `from nucleus.telemetry ...`.
  (defun my-uv-venv-find (file)
    "Walk up from FILE to find a .venv directory; return its absolute path or nil."
    (when file
      (when-let ((dir (locate-dominating-file file ".venv")))
        (let ((venv (expand-file-name ".venv" dir)))
          (and (file-directory-p venv) venv)))))

  (defun my-uv-venv-activate ()
    "Activate the nearest uv-managed .venv for the current python buffer."
    (when (and buffer-file-name (derived-mode-p 'python-mode 'python-ts-mode))
      (when-let ((venv (my-uv-venv-find buffer-file-name)))
        (unless (and (boundp 'pyvenv-virtual-env)
                     pyvenv-virtual-env
                     (string= (file-name-as-directory venv)
                              (file-name-as-directory pyvenv-virtual-env)))
          (pyvenv-activate venv)
          (message "uv venv activated: %s" venv)))))

  ;; Depth -90 so we run before spacemacs' lsp setup on python-mode-hook.
  (add-hook 'python-mode-hook #'my-uv-venv-activate -90)
  (add-hook 'python-ts-mode-hook #'my-uv-venv-activate -90)

  ;; Belt-and-braces: tell lsp-pyright explicitly where the venv lives,
  ;; in case it's consulted before VIRTUAL_ENV is read.
  (with-eval-after-load 'lsp-pyright
    (defun my-lsp-pyright-set-venv ()
      (when-let ((venv (and buffer-file-name
                            (my-uv-venv-find buffer-file-name))))
        (setq-local lsp-pyright-venv-path (file-name-directory
                                           (directory-file-name venv)))))
    (add-hook 'python-mode-hook #'my-lsp-pyright-set-venv -89)
    (add-hook 'python-ts-mode-hook #'my-lsp-pyright-set-venv -89))

  ;; Stop lsp-mode's file watcher from drowning in giant build/venv trees.
  ;; Without this, opening any file under arc hangs while lsp tries to register
  ;; file watches for ~12 G of .venv + 5 G of .uv_cache.
  (with-eval-after-load 'lsp-mode
    (dolist (pat '("[/\\\\]\\.venv\\'"
                   "[/\\\\]\\.uv_cache\\'"
                   "[/\\\\]target\\'"
                   "[/\\\\]node_modules\\'"
                   "[/\\\\]dist\\'"
                   "[/\\\\]build\\'"
                   "[/\\\\]log\\'"
                   "[/\\\\]ros_ws[/\\\\]\\(build\\|install\\|log\\)\\'"
                   "[/\\\\]protogen[/\\\\]\\(ts\\|rust\\|go\\)\\'"))
      (add-to-list 'lsp-file-watch-ignored-directories pat))
    (setq lsp-file-watch-threshold 50000
          lsp-enable-file-watchers t))

  ;; --- C/C++ via clangd running inside the podman dev container ---
  ;; ROS headers live only at /opt/ros/jazzy/include in the container, and
  ;; the workspace is bind-mounted as host /home/hasan/dev/arc -> container /arc.
  ;; The wrapper at ~/.local/bin/clangd-arc-podman does `podman exec` + LSP
  ;; path translation so jump-to-def / xref work transparently.
  (defvar my-arc-root (expand-file-name "~/dev/arc/"))
  (defvar my-arc-hash
    (string-trim
     (shell-command-to-string
      (format "printf '%%s' '%s' | sha256sum | head -c 8"
              (directory-file-name my-arc-root)))))

  (defun my-arc-cpp-container-for (file)
    "Compute the podman dev container name for FILE under arc, or nil."
    (when (and file (string-prefix-p my-arc-root (expand-file-name file)))
      (when-let* ((dir (locate-dominating-file file "pyproject.toml"))
                  (pyproject (expand-file-name "pyproject.toml" dir))
                  (name (with-temp-buffer
                          (insert-file-contents pyproject)
                          (goto-char (point-min))
                          (when (re-search-forward
                                 "^name\\s-*=\\s-*\"\\([^\"]+\\)\"" nil t)
                            (match-string 1)))))
        (unless (string= name "arc")
          (concat name "-dev-" my-arc-hash)))))

  (defun my-arc-cpp-setup ()
    "If this C/C++ buffer is under arc, point clangd at the in-container wrapper."
    (when-let ((container (and buffer-file-name
                               (my-arc-cpp-container-for buffer-file-name))))
      (setq-local lsp-clients-clangd-executable
                  (expand-file-name "~/.local/bin/clangd-arc-podman"))
      (setq-local lsp-clients-clangd-args
                  (list (concat "--arc-container=" container)
                        "--compile-commands-dir=/radical/devel/build"
                        "--background-index"
                        "--header-insertion=never"
                        "--clang-tidy"))))

  (dolist (h '(c-mode-hook c++-mode-hook c-ts-mode-hook c++-ts-mode-hook))
    (add-hook h #'my-arc-cpp-setup -90))

  (defun my-run-pre-commit-after-magit-stage ()
    "Run pre-commit on the staged file if in a valid Python project."
    (when (and (eq major-mode 'python-mode) buffer-file-name)
      (when (my-project-root buffer-file-name)
        (let* ((output-buffer-name "*pre-commit*")
               (command (format "pre-commit run --files %s"
                                (shell-quote-argument buffer-file-name))))

          (display-buffer (get-buffer-create output-buffer-name)
                          `((display-buffer-in-side-window)
                            (side . bottom)
                            (window-height . 10)
                            (preserve-size . (nil . t))
                            (window-parameters . ((no-other-window . t)))))

          (message "Running pre-commit after staging...")
          (async-shell-command command output-buffer-name)))))

  (add-hook 'magit-post-stage-hook #'my-run-pre-commit-after-magit-stage)

  ;; dumb-jump configuration
  (use-package dumb-jump
    :config
    (setq dumb-jump-selector 'helm)
    (setq dumb-jump-force-searcher 'rg)
    (setq dumb-jump-prefer-searcher 'rg)
    (setq dumb-jump-debug nil)  ;; Disable debug
    (setq dumb-jump-aggressive t)  ;; More aggressive searching
    (setq dumb-jump-max-find-time 10)  ;; Increase search time limit
    (setq dumb-jump-confirm-jump-to-modified-file nil)  ;; Don't ask about modified files
    (add-to-list 'dumb-jump-language-file-exts '(:language "python" :ext "py" :agtype "python" :rgtype "py"))
    (dumb-jump-mode))

  ;; spacemacs leader key bindings for dumb-jump
  (spacemacs/set-leader-keys "dj" 'dumb-jump-go)
  (spacemacs/set-leader-keys "dB" 'dumb-jump-back)
  (spacemacs/set-leader-keys "di" 'dumb-jump-go-prompt)
  (spacemacs/set-leader-keys "do" 'dumb-jump-go-other-window)

  ;; Prevent adding final newlines
  ;; (setq require-final-newline nil)
  ;; (setq mode-require-final-newline nil)

  ;; consult-gh configuration (disabled - requires Emacs 29.4+)
  ;; (use-package consult-gh
  ;;   :after consult
  ;;   :custom
  ;;   (consult-gh-default-clone-directory "~/dev")
  ;;   (consult-gh-show-preview t)
  ;;   (consult-gh-preview-key "C-o")
  ;;   (consult-gh-repo-action #'consult-gh--repo-browse-files-action)
  ;;   :config
  ;;   (consult-gh-enable-default-keybindings))

  ;; Optional: Enable embark integration
  ;; (use-package consult-gh-embark
  ;;   :after (consult-gh embark))

  ;; Fix doom-laserwave modeline visibility
  (with-eval-after-load 'doom-themes
    (custom-set-faces
     '(mode-line ((t (:background "#EB64B9" :foreground "#FFFFFF" :box nil))))
     '(mode-line-inactive ((t (:background "#0A0E14" :foreground "#AAAAAA" :box nil))))
     '(spaceline-highlight-face ((t (:background "#EB64B9" :foreground "#FFFFFF" :inherit mode-line))))
     '(powerline-active1 ((t (:background "#EB64B9" :foreground "#FFFFFF" :inherit mode-line))))
     '(powerline-active2 ((t (:background "#EB64B9" :foreground "#FFFFFF" :inherit mode-line))))
     '(powerline-inactive1 ((t (:background "#0A0E14" :foreground "#888888" :inherit mode-line-inactive))))
     '(powerline-inactive2 ((t (:background "#0A0E14" :foreground "#666666" :inherit mode-line-inactive))))))

  ;; Enable clipboard integration in terminal mode
  (unless (display-graphic-p)
    (when (executable-find "xclip")
      (setq interprogram-cut-function
            (lambda (text)
              (with-temp-buffer
                (insert text)
                (call-process-region (point-min) (point-max) "xclip" nil nil nil "-selection" "clipboard"))))
      (setq interprogram-paste-function
            (lambda ()
              (with-temp-buffer
                (call-process "xclip" nil t nil "-selection" "clipboard" "-o")
                (when (> (buffer-size) 0)
                  (buffer-string)))))))

  ;; SSH find-file shortcut
  (defun find-file-ssh ()
    (interactive)
    (minibuffer-with-setup-hook
        (lambda () (insert "/ssh:"))
      (call-interactively 'find-file)))
  (global-set-key (kbd "C-x C-g") 'find-file-ssh)

  ;; mpv video player integration
  (use-package mpv
    :config
    (defun mpv-play-tramp-aware (file)
      (interactive "fVideo file: ")
      (if (tramp-tramp-file-p file)
          (let* ((vec (tramp-dissect-file-name file))
                 (user (tramp-file-name-user vec))
                 (host (tramp-file-name-host vec))
                 (path (tramp-file-name-localname vec))
                 (sftp-url (format "sftp://%s%s%s"
                                   (if user (concat user "@") "")
                                   host
                                   path)))
            (start-process "mpv" nil "mpv" sftp-url))
        (mpv-play file)))
    (defun mpv-play-video-at-point ()
      (interactive)
      (let ((file (dired-get-file-for-visit)))
        (mpv-play-tramp-aware file)))
    (spacemacs/set-leader-keys "av" 'mpv-play-tramp-aware)
    (spacemacs/set-leader-keys "aV" 'mpv-kill)
    (with-eval-after-load 'dired
      (define-key dired-mode-map (kbd "v") 'mpv-play-video-at-point)))
  )


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(package-selected-packages
     '(a ace-jump-helm-line ace-link afternoon-theme aggressive-indent aio
         alect-themes alert all-the-icons ample-theme ample-zen-theme
         anti-zenburn-theme apropospriate-theme auto-compile auto-highlight-symbol
         auto-yasnippet autothemer badwolf-theme birds-of-paradise-plus-theme
         browse-at-remote bubbleberry-theme bui busybee-theme centered-cursor-mode
         cherry-blossom-theme chocolate-theme clean-aindent-mode closql
         clues-theme cmake-mode code-review color-theme-sanityinc-solarized
         color-theme-sanityinc-tomorrow column-enforce-mode company
         company-c-headers consult consult-gh consult-lsp cpp-auto-include
         csv-mode cyberpunk-theme dakrone-theme dap-mode darkmine-theme
         darkokai-theme darktooth-theme deferred define-word devdocs diff-hl
         diminish dired-quick-sort disable-mouse disaster django-theme docker
         dockerfile-mode doom-themes dotenv-mode dracula-theme drag-stuff
         dumb-jump edit-indirect editorconfig ef-themes elisp-def elisp-demos
         elisp-slime-nav emacsql emojify emr espresso-theme eval-sexp-fu evil-anzu
         evil-args evil-cleverparens evil-collection evil-easymotion evil-escape
         evil-evilified-state evil-exchange evil-goggles evil-iedit-state
         evil-indent-plus evil-lion evil-lisp-state evil-matchit evil-mc
         evil-nerd-commenter evil-numbers evil-org evil-surround evil-textobj-line
         evil-tutor evil-unimpaired evil-visual-mark-mode evil-visualstar
         exotica-theme expand-region eyebrowse eziam-themes fancy-battery
         farmhouse-themes flatland-theme flatui-theme flycheck flycheck-elsa
         flycheck-package flycheck-pos-tip flyspell-correct flyspell-correct-helm
         forge gandalf-theme gendoxy ggtags gh-md ghub git-link git-messenger
         git-modes git-timemachine gitignore-templates gntp gnuplot golden-ratio
         google-c-style google-translate gotham-theme grandshell-theme
         gruber-darker-theme gruvbox-theme hc-zenburn-theme helm-ag
         helm-c-yasnippet helm-comint helm-company helm-ctest helm-descbinds
         helm-git-grep helm-ls-git helm-lsp helm-make helm-mode-manager helm-org
         helm-org-rifle helm-projectile helm-purpose helm-swoop helm-themes
         helm-xref hemisu-theme heroku-theme hide-comnt highlight-indentation
         highlight-numbers highlight-parentheses hl-todo holy-mode htmlize
         hungry-delete hybrid-mode indent-guide info+ inkpot-theme inspector
         ir-black-theme jazz-theme jbeans-theme js-doc js2-mode js2-refactor
         json-mode json-navigator json-reformat json-snatcher kaolin-themes
         light-soap-theme link-hint livid-mode llama load-env-vars log4e
         lorem-ipsum lsp-docker lsp-mode lsp-origami lsp-pyright lsp-treemacs
         lsp-ui lush-theme macrostep madhat2r-theme magit magit-section
         markdown-mode markdown-toc material-theme minimal-theme modus-themes
         moe-theme molokai-theme monochrome-theme monokai-theme multi-line
         multi-vterm multiple-cursors mustang-theme mwim nameless naquadah-theme
         noctilux-theme nodejs-repl npm-mode obsidian-theme occidental-theme
         oldlace-theme omtose-phellack-themes open-junk-file org
         org-category-capture org-cliplink org-contrib org-download org-mime
         org-pomodoro org-present org-project-capture org-projectile org-rich-yank
         org-superstar organic-green-theme origami overseer ox-gfm package-lint
         page-break-lines paradox password-generator pcre2el pet
         phoenix-dark-mono-theme phoenix-dark-pink-theme pip-requirements pipenv
         pippel planet-theme poetry popwin pos-tip prettier-js professional-theme
         protobuf-mode purple-haze-theme py-isort pydoc pyenv-mode pylookup pytest
         pythonic pyvenv quickrun railscasts-theme rainbow-delimiters
         rebecca-theme reformatter restart-emacs reverse-theme ron-mode
         ruff-format rust-mode rustic seti-theme shell-pop simple-httpd
         skewer-mode slim-mode smeargle smyx-theme soft-charcoal-theme
         soft-morning-theme soft-stone-theme solarized-theme soothe-theme
         space-doc spacegray-theme spaceline spacemacs-purpose-popwin
         spacemacs-whitespace-cleanup sphinx-doc string-edit-at-point
         string-inflection subatomic-theme subatomic256-theme sublime-themes
         sunny-day-theme symbol-overlay symon tablist tagedit tango-2-theme
         tango-plus-theme tangotango-theme tao-theme term-cursor terminal-here
         toc-org toxi-theme transient treemacs-evil treemacs-icons-dired
         treemacs-magit treemacs-persp treemacs-projectile treepy
         twilight-anti-bright-theme twilight-bright-theme twilight-theme
         ujelly-theme underwater-theme undo-fu undo-fu-session unfill uuidgen
         vi-tilde-fringe volatile-highlights vterm vundo web-beautify web-mode
         wgrep which-key white-sand-theme winum with-editor writeroom-mode
         ws-butler xcscope xref xterm-color yaml yaml-mode yapfify yasnippet
         yasnippet-snippets zen-and-art-theme zenburn-theme zonokai-emacs)))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:background nil))))
   '(mode-line ((t (:background "#EB64B9" :foreground "#FFFFFF" :box nil))))
   '(mode-line-inactive ((t (:background "#0A0E14" :foreground "#AAAAAA" :box nil))))
   '(powerline-active1 ((t (:background "#EB64B9" :foreground "#FFFFFF" :inherit mode-line))))
   '(powerline-active2 ((t (:background "#EB64B9" :foreground "#FFFFFF" :inherit mode-line))))
   '(powerline-inactive1 ((t (:background "#0A0E14" :foreground "#888888" :inherit mode-line-inactive))))
   '(powerline-inactive2 ((t (:background "#0A0E14" :foreground "#666666" :inherit mode-line-inactive))))
   '(spaceline-highlight-face ((t (:background "#EB64B9" :foreground "#FFFFFF" :inherit mode-line)))))
  )
