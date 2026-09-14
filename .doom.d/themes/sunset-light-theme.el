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
;;; Time of day

(defcustom sunset-light-darkness nil
  "Override for the darkness read from `sunset-light-darkness-file'."
  :group 'sunset-light-theme
  :type '(choice (const nil) float))

(defcustom sunset-light-darkness-file (expand-file-name "~/.local/state/sun-theme/darkness")
  "File holding a 0..1 darkness written by sun-theme: 0 at solar noon, 1 at solar midnight."
  :group 'sunset-light-theme
  :type 'file)

(defconst sunset-light--bg-keyframes
  '((0.0 . "#fdf8f5") (0.35 . "#f6bdb3") (0.65 . "#6b5570") (1.0 . "#1c2540"))
  "Background across the day: midday, sunset, deep dusk, midnight.")

(defun sunset-light--darkness ()
  (or sunset-light-darkness
      (ignore-errors
        (with-temp-buffer
          (insert-file-contents sunset-light-darkness-file)
          (min 1.0 (max 0.0 (float (string-to-number (buffer-string)))))))
      0.0))

(defun sunset-light--luminance (hex)
  "WCAG relative luminance of HEX, 0 (black) to 1 (white)."
  (let ((lin (lambda (c) (if (<= c 0.03928) (/ c 12.92) (expt (/ (+ c 0.055) 1.055) 2.4)))))
    (pcase-let ((`(,r ,g ,b) (doom-name-to-rgb hex)))
      (+ (* 0.2126 (funcall lin r)) (* 0.7152 (funcall lin g)) (* 0.0722 (funcall lin b))))))

(defun sunset-light--contrast (a b)
  "WCAG contrast ratio between colours A and B."
  (let ((la (+ (sunset-light--luminance a) 0.05))
        (lb (+ (sunset-light--luminance b) 0.05)))
    (/ (max la lb) (min la lb))))

(defun sunset-light--readable (color bg &optional target)
  "Push COLOR away from BG until it reaches TARGET contrast (default 4.5)."
  (let ((target (or target 4.5))
        (dark (< (sunset-light--luminance bg) 0.18))
        (c color) (i 0))
    (while (and (< (sunset-light--contrast c bg) target) (< i 24))
      (setq c (if dark (doom-lighten c 0.08) (doom-darken c 0.08))
            i (1+ i)))
    c))

(defun sunset-light--keyframe (frames d)
  "Piecewise-linear colour from FRAMES at position D."
  (let ((prev (car frames)) (rest (cdr frames)))
    (while (and rest (> d (car (car rest))))
      (setq prev (car rest) rest (cdr rest)))
    (if (null rest)
        (cdr prev)
      (let* ((next (car rest))
             (span (- (car next) (car prev)))
             (a (if (zerop span) 1.0 (/ (- d (car prev)) span))))
        (doom-blend (cdr next) (cdr prev) a)))))


;;
;;; Theme definition

(def-doom-theme sunset-light
  "A warm, minimal theme drawn from a Santorini sunset; darkens with the sun."
  :family 'sunset
  :background-mode 'light

  ;; name        default   256       16
  ((darkness   (sunset-light--darkness))
   (bg-hex     (sunset-light--keyframe sunset-light--bg-keyframes darkness))
   ;; below ~0.18 white text out-contrasts dark text
   (dark       (< (sunset-light--luminance bg-hex) 0.18))
   (fg-hex     (sunset-light--readable (if dark "#fdf8f5" "#3b3238") bg-hex 4.5))
   (mix        (lambda (a) (doom-blend fg-hex bg-hex a)))
   ;; text accents keep their hue but are pushed away from the bg until legible
   (accent     (lambda (light-hex dark-hex) (sunset-light--readable (if dark dark-hex light-hex) bg-hex 3.5)))

   (bg         (list bg-hex "white"   "white"        ))
   (fg         (list fg-hex "#3a3a3a" "black"        ))

   (bg-alt     (list (funcall mix 0.04) "white"   "white"        ))
   (fg-alt     (list (funcall mix 0.58) "#8a8a8a" "brightblack"  ))

   (base0      (list (if dark (doom-darken bg-hex 0.3) (doom-lighten bg-hex 0.5)) "#ffffff" "white"))
   (base1      (list (funcall mix 0.04) "#f0f0f0" "brightblack"  ))
   (base2      (list (funcall mix 0.08) "#e5e5e5" "brightblack"  ))
   (base3      (list (funcall mix 0.14) "#d0d0d0" "brightblack"  ))
   (base4      (list (funcall mix 0.36) "#a8a8a8" "brightblack"  ))
   (base5      (list (funcall mix 0.58) "#808080" "brightblack"  ))
   (base6      (list (funcall mix 0.82) "#5a5a5a" "brightblack"  ))
   (base7      (list fg-hex "#3a3a3a" "brightblack"  ))
   (base8      (list (if dark "#ffffff" "#241d21") "black"   "black"        ))

   ;; brand palette
   (peach      '("#ffccbb" "#ffd7c4" "brightred"    ))
   (coral      '("#f78d7d" "#ff8787" "red"          ))
   (rose       '("#cb9897" "#d7a4a4" "brightmagenta"))
   (sky        '("#9bb9c3" "#a3c1cb" "brightcyan"   ))
   (mauve      '("#947481" "#9c7f8b" "magenta"      ))

   ;; text accents: darkened for a light bg, pastel once the bg turns dark
   (grey       base4)
   (red        (list (funcall accent "#b84f43" "#f78d7d") "#b04b40" "red"          ))
   (orange     (list (funcall accent "#b8662f" "#f2a87e") "#b86a33" "brightred"    ))
   (green      (list (funcall accent "#3f7d6e" "#8cc4b3") "#3f7d6e" "green"        ))
   (teal       (list (funcall accent "#44727f" "#9bb9c3") "#457580" "brightgreen"  ))
   (yellow     (list (funcall accent "#a56d2e" "#e6b986") "#a56d2e" "yellow"       ))
   (blue       (list (funcall accent "#44727f" "#9bb9c3") "#457580" "brightblue"   ))
   (dark-blue  (list (funcall accent "#2f5560" "#7e9daa") "#2f5560" "blue"         ))
   (magenta    (list (funcall accent "#7a5868" "#cb9897") "#7a5868" "magenta"      ))
   (violet     (list (funcall accent "#5e4453" "#c3a6b8") "#5e4453" "brightmagenta"))
   (cyan       (list (funcall accent "#44727f" "#9bb9c3") "#457580" "brightcyan"   ))
   (dark-cyan  (list (funcall accent "#2f5560" "#7e9daa") "#2f5560" "cyan"         ))

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
   ;; a lighter wash on light bgs, a deeper one once text is white
   (region         `(,(doom-blend (car peach) (car bg) (if dark 0.3 0.55)) ,@(cdr peach)))
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
