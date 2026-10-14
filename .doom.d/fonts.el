;;; fonts.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Iosevka" :size 14 :weight 'normal))

;; Weight complements the theme's colors; Doom reapplies these after theme changes.
(custom-set-faces!
  '((font-lock-comment-face font-lock-comment-delimiter-face font-lock-doc-face)
    :weight light)
  '((font-lock-string-face font-lock-variable-name-face font-lock-variable-use-face
     font-lock-property-name-face font-lock-property-use-face
     font-lock-operator-face font-lock-punctuation-face font-lock-bracket-face
     font-lock-delimiter-face)
    :weight normal)
  '((font-lock-builtin-face font-lock-constant-face font-lock-number-face
     font-lock-function-call-face)
    :weight medium)
  '((font-lock-keyword-face font-lock-type-face font-lock-preprocessor-face)
    :weight semi-bold)
  '(font-lock-function-name-face :weight bold)
  '(font-lock-warning-face :weight extra-bold))

(after! highlight-numbers
  (custom-set-faces!
    '(highlight-numbers-number :weight medium)))

;; Semantic tokens distinguish references from definitions when the server can.
(after! lsp-semantic-tokens
  (custom-set-faces!
    '((lsp-face-semhl-function lsp-face-semhl-method) :weight medium)
    '(lsp-face-semhl-namespace :weight semi-bold)
    '(lsp-face-semhl-operator :weight normal)
    '((lsp-face-semhl-definition lsp-face-semhl-implementation) :weight bold)))
