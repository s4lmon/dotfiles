;;; kitty-theme.el --- export the active Doom theme to kitty, starship and tmux -*- lexical-binding: t; -*-

(defvar hasan/kitty-dir (expand-file-name "~/.config/kitty/")
  "Kitty config directory; themes are written to its themes/ subdirectory.")

(defvar hasan/tmux-theme (expand-file-name "~/.config/tmux/theme.conf")
  "Generated tmux colour file, sourced from .tmux.conf.")

(defvar hasan/starship-conf (expand-file-name "~/.config/starship.toml")
  "Starship config; a palette named after the Doom theme is maintained inside it.")

(defvar hasan/borders-rc (expand-file-name "~/.config/borders/bordersrc")
  "JankyBorders config (AeroSpace window borders on macOS).")

(defun hasan/kt--color (&rest names)
  "First defined colour among NAMES in the active Doom theme."
  (seq-some (lambda (n) (ignore-errors (doom-color n))) names))

(defun hasan/kt--luminance (hex)
  "WCAG relative luminance of HEX, 0 (black) to 1 (white)."
  (let ((lin (lambda (c) (if (<= c 0.03928) (/ c 12.92) (expt (/ (+ c 0.055) 1.055) 2.4)))))
    (pcase-let ((`(,r ,g ,b) (doom-name-to-rgb hex)))
      (+ (* 0.2126 (funcall lin r)) (* 0.7152 (funcall lin g)) (* 0.0722 (funcall lin b))))))

(defun hasan/kt--contrast (a b)
  (let ((la (+ (hasan/kt--luminance a) 0.05)) (lb (+ (hasan/kt--luminance b) 0.05)))
    (/ (max la lb) (min la lb))))

(defun hasan/kt--light-p (bg)
  "Non-nil when dark text reads better than white on BG."
  (>= (hasan/kt--luminance bg) 0.18))

(defun hasan/kt--palette ()
  "Kitty setting -> hex colour alist derived from the current Doom palette."
  (let* ((bg (doom-color 'bg)) (fg (doom-color 'fg))
         (light (hasan/kt--light-p bg))
         (peach (hasan/kt--color 'peach 'orange))
         (coral (hasan/kt--color 'coral 'red))
         (sky (hasan/kt--color 'sky 'cyan))
         (mauve (hasan/kt--color 'mauve 'magenta))
         (bright (lambda (c) (if light (doom-lighten c 0.2) (doom-lighten c 0.15)))))
    `((background . ,bg)
      (foreground . ,fg)
      (cursor . ,(doom-darken coral 0.1))
      (cursor_text_color . ,bg)
      (selection_background . ,peach)
      (selection_foreground . ,(if light fg (doom-color 'base0)))
      (url_color . ,(doom-color 'blue))
      (active_tab_background . ,peach)
      (active_tab_foreground . ,(if light fg (doom-color 'base0)))
      (inactive_tab_background . ,(doom-color 'base2))
      (inactive_tab_foreground . ,(doom-color 'base5))
      (tab_bar_background . ,(doom-color 'base1))
      (active_border_color . ,coral)
      (inactive_border_color . ,(doom-color 'base3))
      (color0 . ,(if light (doom-color 'base7) (doom-color 'base0)))
      (color8 . ,(doom-color 'base5))
      (color1 . ,(doom-color 'red))
      (color9 . ,(doom-darken coral 0.1))
      (color2 . ,(doom-color 'green))
      (color10 . ,(funcall bright (doom-color 'green)))
      (color3 . ,(doom-color 'yellow))
      (color11 . ,(funcall bright (doom-color 'yellow)))
      (color4 . ,(doom-color 'blue))
      (color12 . ,(funcall bright (doom-color 'blue)))
      (color5 . ,(doom-color 'magenta))
      (color13 . ,mauve)
      (color6 . ,(doom-color 'cyan))
      (color14 . ,sky)
      (color7 . ,(if light (doom-color 'base3) (doom-color 'base7)))
      (color15 . ,(if light bg fg)))))

(defun hasan/kt--starship-palette ()
  "Starship palette name -> hex alist derived from the current Doom palette.
On light themes segment backgrounds are pale warm tints so dark text stays
legible; text_* entries are the untinted colours for glyphs drawn on bg."
  (let* ((bg (doom-color 'bg)) (fg (doom-color 'fg))
         (light (hasan/kt--light-p bg))
         (tint (lambda (c a) (if light (doom-blend c bg a) c)))
         (pick (lambda (brand base a)
                 (or (hasan/kt--color brand) (funcall tint (doom-color base) a))))
         (coral (funcall pick 'coral 'red 0.5))
         (peach (funcall pick 'peach 'orange 0.4))
         (rose (funcall pick 'rose 'magenta 0.4))
         (mauve (funcall pick 'mauve 'violet 0.6))
         (segments (list coral peach (funcall tint (doom-color 'yellow) 0.3) (funcall tint rose 0.6)
                         (if light (funcall tint mauve 0.4) (doom-lighten mauve 0.25))))
         ;; segment text: first of fg, bg, deep shade that is legible on every segment
         (worst (lambda (c) (apply #'min (mapcar (lambda (s) (hasan/kt--contrast c s)) segments))))
         (candidates (list fg bg (doom-darken bg 0.5)))
         (crust (or (seq-find (lambda (c) (>= (funcall worst c) 4.0)) candidates)
                    (car (seq-sort-by worst #'> candidates)))))
    `((red . ,coral)
      (peach . ,peach)
      (yellow . ,(funcall tint (doom-color 'yellow) 0.3))
      (green . ,(funcall tint rose 0.6))
      (teal . ,(funcall tint peach 0.6))
      (sapphire . ,(funcall tint coral 0.4))
      (blue . ,(funcall tint peach 0.6))
      (lavender . ,(nth 4 segments))
      (mauve . ,mauve)
      (text_red . ,(doom-color 'red))
      (text_green . ,(doom-color 'green))
      (text_yellow . ,(doom-color 'yellow))
      (text_lavender . ,(doom-color 'violet))
      (text . ,fg)
      (subtext0 . ,(doom-color 'base5))
      (overlay0 . ,(doom-color 'base4))
      (surface0 . ,(doom-color 'base2))
      (base . ,bg)
      (crust . ,crust))))

(defun hasan/kt--set-include (theme)
  "Point kitty.conf's theme include at THEME."
  (let ((conf (expand-file-name "kitty.conf" hasan/kitty-dir))
        (line (format "include themes/%s.conf" theme)))
    (with-temp-buffer
      (insert-file-contents conf)
      (goto-char (point-min))
      (if (re-search-forward "^include themes/.*\\.conf$" nil t)
          (replace-match line t t)
        (insert line "\n"))
      (write-region nil nil conf))))

(defun hasan/kt--write-kitty (name)
  (let ((out (expand-file-name (format "themes/%s.conf" name) hasan/kitty-dir)))
    (make-directory (file-name-directory out) t)
    (with-temp-file out
      (insert (format "# %s — generated from the Doom theme by kitty-theme.el; do not edit\n\n" name))
      (dolist (kv (hasan/kt--palette))
        (insert (format "%-24s %s\n" (car kv) (cdr kv)))))
    (hasan/kt--set-include name)
    out))

(defun hasan/kt--write-tmux (name)
  "Write tmux status and border colours from the kitty palette."
  (let* ((p (hasan/kt--palette))
         (c (lambda (k) (alist-get k p)))
         (accent (funcall c 'active_border_color))
         (tab-bg (funcall c 'active_tab_background))
         (tab-fg (funcall c 'active_tab_foreground))
         (dark (funcall c (quote color0))))
    (make-directory (file-name-directory hasan/tmux-theme) t)
    (with-temp-file hasan/tmux-theme
      (insert (format "# %s — generated from the Doom theme by kitty-theme.el; do not edit\n" name))
      (dolist (line
               (list
                (format "set -g status-style \"bg=%s,fg=%s\"" accent dark)
                (format "set -g status-left-style \"bg=%s,fg=%s,bold\"" tab-bg tab-fg)
                (format "set -g status-right-style \"bg=%s,fg=%s\"" accent dark)
                (format "setw -g window-status-current-style \"bg=%s,fg=%s,bold\"" tab-bg tab-fg)
                (format "set -g pane-border-style \"fg=%s\"" (funcall c 'inactive_border_color))
                (format "set -g pane-active-border-style \"fg=%s\"" accent)
                (format "set -g message-style \"bg=%s,fg=%s\"" tab-bg tab-fg)
                (format "set -g mode-style \"bg=%s,fg=%s\""
                        (funcall c 'selection_background) (funcall c 'selection_foreground))))
        (insert line "\n")))
    (call-process "tmux" nil nil nil "source-file" (expand-file-name "~/.tmux.conf"))))

(defun hasan/kt--write-starship (name)
  "Replace the [palettes.NAME] table in starship.toml and select it."
  (with-temp-buffer
    (insert-file-contents hasan/starship-conf)
    (goto-char (point-min))
    (if (re-search-forward "^palette = .*$" nil t)
        (replace-match (format "palette = '%s'" name) t t)
      (insert (format "palette = '%s'\n" name)))
    (goto-char (point-min))
    (when (re-search-forward (format "^\\[palettes\\.%s\\]\n" (regexp-quote name)) nil t)
      (delete-region (match-beginning 0)
                     (if (re-search-forward "^\\[" nil t) (match-beginning 0) (point-max))))
    (goto-char (point-max))
    (skip-chars-backward "\n")
    (delete-region (point) (point-max))
    (insert (format "\n\n[palettes.%s]\n# generated from the Doom theme by kitty-theme.el; do not edit\n" name))
    (dolist (kv (hasan/kt--starship-palette))
      (insert (format "%s = \"%s\"\n" (car kv) (cdr kv))))
    (write-region nil nil hasan/starship-conf)))

(defun hasan/kt--write-borders (name)
  "Write JankyBorders colours from the kitty palette and push them to a running instance."
  (let* ((p (hasan/kt--palette))
         (argb (lambda (k) (concat "0xff" (substring (alist-get k p) 1))))
         (opts (list "style=round" "width=6.0" "hidpi=on"
                     (concat "active_color=" (funcall argb 'active_border_color))
                     (concat "inactive_color=" (funcall argb 'inactive_border_color)))))
    (make-directory (file-name-directory hasan/borders-rc) t)
    (with-temp-file hasan/borders-rc
      (insert (format "#!/bin/bash\n# %s — generated from the Doom theme by kitty-theme.el; do not edit\n" name))
      (insert (format "options=(%s)\n" (mapconcat #'identity opts " ")))
      (insert "borders \"${options[@]}\"\n"))
    (set-file-modes hasan/borders-rc #o755)
    (when (executable-find "borders")
      (let ((process (apply #'start-process "theme-borders" nil "borders" opts)))
        (set-process-query-on-exit-flag process nil)))))

(defun hasan/kitty-theme-export ()
  "Write the active Doom theme to kitty and starship, then reload kitty."
  (interactive)
  (unless doom-theme (user-error "No Doom theme loaded"))
  (let* ((name (symbol-name doom-theme))
         (out (hasan/kt--write-kitty name)))
    (hasan/kt--write-starship name)
    (hasan/kt--write-tmux name)
    (when (eq system-type 'darwin)
      (hasan/kt--write-borders name))
    (call-process "pkill" nil nil nil "-USR1" "-x" "kitty")
    (message "kitty + starship + tmux themes written: %s" out)))

(add-hook 'doom-load-theme-hook #'hasan/kitty-theme-export)

(provide 'kitty-theme)
;;; kitty-theme.el ends here
