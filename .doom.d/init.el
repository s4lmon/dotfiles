;;; init.el -*- lexical-binding: t; -*-

(doom! :completion
       (corfu +orderless +icons)
       (vertico +icons)

       :ui
       doom
       doom-dashboard
       hl-todo
       indent-guides
       ligatures
       modeline
       nav-flash
       ophints
       (popup +defaults)
       smooth-scroll
       (vc-gutter +pretty)
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       format
       multiple-cursors
       snippets

       :emacs
       (dired +dirvish)
       electric
       undo
       vc

       :term
       vterm

       :checkers
       syntax
       (spell +aspell)

       :tools
       docker
       (eval +overlay)
       lookup
       lsp
       (magit +forge)
       make
       tree-sitter

       :os
       tty

       :lang
       (cc +lsp)
       emacs-lisp
       (go +lsp)
       (json +lsp)
       (javascript +lsp)
       markdown
       org
       (python +lsp +pyright)
       (rust +lsp)
       sh
       (web +lsp)
       (yaml +lsp)

       :config
       (default +bindings +smartparens))
