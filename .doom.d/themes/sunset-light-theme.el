;;; sunset-light-theme.el --- a warm, minimal light theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Author: Hasan Amin
;; Palette: Santorini sunset — #FFCCBB #F78D7D #CB9897 #9BB9C3 #947481
;; Inspired by the near-monochrome approach of mindre-theme.
;;
;;; Commentary:
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup sunset-light-theme nil
  "Options for the `sunset-light' theme."
  :group 'doom-themes)

(defcustom sunset-light-brighter-comments nil
  "If non-nil, comments use the dusty rose accent instead of muted grey."
  :group 'sunset-light-theme
  :type 'boolean)

(defcustom sunset-light-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'sunset-light-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme sunset-light
  "A warm, minimal light theme drawn from a Santorini sunset."
  :family 'sunset
  :background-mode 'light

  ;; name        default   256       16
  ((bg         '("#fdf8f5" "white"   "white"        ))
   (fg         '("#3b3238" "#3a3a3a" "black"        ))

   (bg-alt     '("#f6ede9" "white"   "white"        ))
   (fg-alt     '("#8d7c84" "#8a8a8a" "brightblack"  ))

   (base0      '("#fffcfa" "#ffffff" "white"        ))
   (base1      '("#f6ede9" "#f0f0f0" "brightblack"  ))
   (base2      '("#efe2dd" "#e5e5e5" "brightblack"  ))
   (base3      '("#e2d1cc" "#d0d0d0" "brightblack"  ))
   (base4      '("#b8a6ab" "#a8a8a8" "brightblack"  ))
   (base5      '("#8d7c84" "#808080" "brightblack"  ))
   (base6      '("#5e4f57" "#5a5a5a" "brightblack"  ))
   (base7      '("#3b3238" "#3a3a3a" "brightblack"  ))
   (base8      '("#241d21" "black"   "black"        ))

   ;; brand palette
   (peach      '("#ffccbb" "#ffd7c4" "brightred"    ))
   (coral      '("#f78d7d" "#ff8787" "red"          ))
   (rose       '("#cb9897" "#d7a4a4" "brightmagenta"))
   (sky        '("#9bb9c3" "#a3c1cb" "brightcyan"   ))
   (mauve      '("#947481" "#9c7f8b" "magenta"      ))

   ;; darkened variants readable as text on bg
   (grey       base4)
   (red        '("#b84f43" "#b04b40" "red"          ))
   (orange     '("#b8662f" "#b86a33" "brightred"    ))
   (green      '("#3f7d6e" "#3f7d6e" "green"        ))
   (teal       '("#44727f" "#457580" "brightgreen"  ))
   (yellow     '("#a56d2e" "#a56d2e" "yellow"       ))
   (blue       '("#44727f" "#457580" "brightblue"   ))
   (dark-blue  '("#2f5560" "#2f5560" "blue"         ))
   (magenta    '("#7a5868" "#7a5868" "magenta"      ))
   (violet     '("#5e4453" "#5e4453" "brightmagenta"))
   (cyan       '("#44727f" "#457580" "brightcyan"   ))
   (dark-cyan  '("#2f5560" "#2f5560" "cyan"         ))

   ;; universal syntax classes — deliberately near-monochrome:
   ;; keywords mauve, types sky, strings coral, everything else fg
   (highlight      coral)
   (vertical-bar   base2)
   (selection      peach)
   (builtin        fg)
   (comments       (if sunset-light-brighter-comments (doom-darken rose 0.25) base5))
   (doc-comments   (doom-darken comments 0.1))
   (constants      violet)
   (functions      fg)
   (keywords       magenta)
   (methods        fg)
   (operators      fg)
   (type           blue)
   (strings        red)
   (variables      fg)
   (numbers        violet)
   (region         `(,(doom-blend (car peach) (car bg) 0.55) ,@(cdr peach)))
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    blue)
   (vc-added       green)
   (vc-deleted     red)

   (modeline-fg              fg)
   (modeline-fg-alt          base5)
   (modeline-bg              base2)
   (modeline-bg-alt          base1)
   (modeline-bg-inactive     base1)
   (modeline-bg-alt-inactive base0)

   (-modeline-pad
    (when sunset-light-padded-modeline
      (if (integerp sunset-light-padded-modeline) sunset-light-padded-modeline 4))))

  ;;;; Base theme face overrides
  (((font-lock-comment-face &override) :slant 'italic)
   ((font-lock-doc-face &override) :slant 'italic)
   ((font-lock-function-name-face &override) :weight 'semi-bold)
   ((font-lock-constant-face &override) :weight 'semi-bold)
   ((font-lock-keyword-face &override) :weight 'normal)
   ((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground base7 :weight 'bold)
   (hl-line :background (doom-blend peach bg 0.22))
   (cursor :background (doom-darken coral 0.1))
   (link :foreground blue :underline t)
   (minibuffer-prompt :foreground magenta :weight 'bold)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground magenta :weight 'bold)
   (shadow :foreground base4)
   (tooltip :background base1 :foreground fg)
   (show-paren-match :background peach :foreground base8 :weight 'bold)
   (lazy-highlight :background (doom-blend sky bg 0.45) :foreground fg)
   (isearch :background coral :foreground base0 :weight 'bold)

   ;;;; doom-modeline
   (doom-modeline-bar :background coral)
   (doom-modeline-buffer-file :foreground fg :weight 'bold)
   (doom-modeline-buffer-modified :foreground red :weight 'bold)
   (doom-modeline-project-dir :foreground magenta :weight 'bold)
   (doom-modeline-evil-insert-state :foreground green)
   (doom-modeline-evil-normal-state :foreground blue)
   (doom-modeline-evil-visual-state :foreground orange)
   ;;;; ediff <built-in>
   (ediff-current-diff-A        :foreground red   :background (doom-blend red bg 0.15))
   (ediff-current-diff-B        :foreground green :background (doom-blend green bg 0.15))
   (ediff-current-diff-C        :foreground blue  :background (doom-blend blue bg 0.15))
   ;;;; diff-hl / git-gutter
   (diff-hl-change :foreground sky :background sky)
   (diff-hl-insert :foreground green :background (doom-lighten green 0.5))
   (diff-hl-delete :foreground coral :background coral)
   ;;;; lsp-mode
   (lsp-ui-doc-background :background base0)
   ;;;; magit
   (magit-blame-heading :foreground magenta :background bg-alt)
   (magit-diff-added :foreground green :background (doom-blend green bg 0.12))
   (magit-diff-added-highlight :foreground green :background (doom-blend green bg 0.22) :weight 'bold)
   (magit-diff-removed :foreground red :background (doom-blend red bg 0.12))
   (magit-diff-removed-highlight :foreground red :background (doom-blend red bg 0.22) :weight 'bold)
   (magit-section-heading :foreground magenta :weight 'bold)
   ;;;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground magenta)
   ((markdown-code-face &override) :background base1)
   (mmm-default-submode-face :background base1)
   ;;;; outline <built-in>
   ((outline-1 &override) :foreground magenta)
   ((outline-2 &override) :foreground blue)
   ((outline-3 &override) :foreground red)
   ((outline-4 &override) :foreground violet)
   ;;;; org <built-in>
   ((org-block &override) :background base1)
   ((org-block-begin-line &override) :foreground base5 :background base1 :slant 'italic)
   (org-ellipsis :underline nil :background bg :foreground coral)
   ((org-quote &override) :background base1)
   (org-todo :foreground red :weight 'bold)
   (org-done :foreground green :weight 'bold)
   (org-date :foreground blue :underline t)
   ;;;; vertico / corfu
   (vertico-current :background base2)
   (corfu-current :background base2)
   (corfu-default :background base0 :foreground fg)
   (orderless-match-face-0 :foreground red :weight 'bold)
   (orderless-match-face-1 :foreground magenta :weight 'bold)
   (orderless-match-face-2 :foreground blue :weight 'bold)
   (orderless-match-face-3 :foreground green :weight 'bold)
   ;;;; solaire-mode
   (solaire-default-face :background bg-alt)
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-alt-inactive
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt-inactive)))
   ;;;; rainbow-delimiters: keep quiet, monochrome-ish
   (rainbow-delimiters-depth-1-face :foreground fg)
   (rainbow-delimiters-depth-2-face :foreground magenta)
   (rainbow-delimiters-depth-3-face :foreground blue)
   (rainbow-delimiters-depth-4-face :foreground base5)
   ;;;; web-mode
   (web-mode-current-element-highlight-face :background peach :foreground base8)
   ;;;; wgrep <built-in>
   (wgrep-face :background base1)
   ;;;; whitespace
   ((whitespace-tab &override)         :background (if (not (default-value 'indent-tabs-mode)) base0 'unspecified))
   ((whitespace-indentation &override) :background (if (default-value 'indent-tabs-mode) base0 'unspecified)))

  ;;;; Base theme variable overrides
  ()
  )

;;; sunset-light-theme.el ends here
