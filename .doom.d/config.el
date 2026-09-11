;;; config.el -*- lexical-binding: t; -*-

(setq doom-theme 'sunset-light
      doom-themes-padded-modeline t
      doom-font (font-spec :family "monospace" :size 14))

;; major-mode leader on "," like Spacemacs
(setq doom-localleader-key ","
      doom-localleader-alt-key "M-,")

(setq scroll-conservatively 101
      scroll-margin 3)

(after! corfu
  (setq corfu-auto-delay 0.2))

;; snap-packaged Firefox cannot read /tmp, so browser previews must live in $HOME
(setq browse-url-temp-dir (expand-file-name "~/tmp"))
;; explicit CDN URL: Ubuntu's pandoc defaults --katex to a local path that
;; snap-packaged Firefox cannot read anyway
(setq markdown-command "pandoc -f gfm -t html5 --katex=https://cdn.jsdelivr.net/npm/katex@0.16/dist/ -s")

;; auto-register repos under ~/dev on startup
(setq projectile-project-search-path '("~/dev"))

(after! projectile
  (setq projectile-enable-caching t
        projectile-globally-ignored-file-suffixes '(".whl" ".log" ".txt")
        projectile-globally-ignored-files '("*[0-9][0-9][0-9][0-9][0-9]*")))

(after! forge
  (add-to-list 'forge-alist
               '("gitlab.werewolf-banded.ts.net"
                 "gitlab.werewolf-banded.ts.net/api/v4"
                 "gitlab.werewolf-banded.ts.net"
                 forge-gitlab-repository)))

;; RET / click in magit diffs always visit the editable worktree file,
;; never the read-only .~{index}~ / .~HEAD~ blob
(after! magit
  ;; status pops into a side-by-side window instead of taking the current one
  (setq magit-display-buffer-function #'magit-display-buffer-traditional)
  (define-key magit-file-section-map (kbd "RET") #'magit-diff-visit-worktree-file)
  (define-key magit-hunk-section-map (kbd "RET") #'magit-diff-visit-worktree-file)
  (define-key magit-file-section-map [remap magit-visit-thing] #'magit-diff-visit-worktree-file)
  (define-key magit-hunk-section-map [remap magit-visit-thing] #'magit-diff-visit-worktree-file))

;; Spacemacs-style window numbers (overrides Doom's SPC 1-9 workspace switching;
;; workspaces remain reachable via SPC TAB 1-9)
(use-package! winum
  :config
  (setq winum-auto-setup-mode-line nil)
  (winum-mode)
  (map! :leader
        :desc "Sidebar (dirvish)" "0" #'dirvish-side
        :desc "Window 1" "1" #'winum-select-window-1
        :desc "Window 2" "2" #'winum-select-window-2
        :desc "Window 3" "3" #'winum-select-window-3
        :desc "Window 4" "4" #'winum-select-window-4
        :desc "Window 5" "5" #'winum-select-window-5
        :desc "Window 6" "6" #'winum-select-window-6
        :desc "Window 7" "7" #'winum-select-window-7
        :desc "Window 8" "8" #'winum-select-window-8
        :desc "Window 9" "9" #'winum-select-window-9))

;; Spacemacs muscle memory: SPC g s = status, SPC a = applications
;; (embark-act stays on C-;)
(map! :leader
      :desc "M-x" "SPC" #'execute-extended-command
      :desc "Magit status" "g s" #'magit-status
      (:prefix ("a" . "applications")
       :desc "Dired" "d" #'dired))

;; smerge-mode toggle and navigation
(defvar smerge-original-bindings nil
  "Store original keybindings to restore when exiting smerge-mode.")

(defun smerge-mode-toggle ()
  "Toggle smerge-mode and set up local keybindings."
  (interactive)
  (require 'smerge-mode)
  (if (bound-and-true-p smerge-mode)
      (progn
        (when smerge-original-bindings
          (dolist (binding smerge-original-bindings)
            (evil-local-set-key 'normal (kbd (car binding)) (cdr binding)))
          (setq smerge-original-bindings nil))
        (smerge-mode -1)
        (message "smerge-mode disabled"))
    (progn
      (setq smerge-original-bindings
            (list (cons "j" (lookup-key evil-normal-state-local-map (kbd "j")))
                  (cons "k" (lookup-key evil-normal-state-local-map (kbd "k")))
                  (cons "l" (lookup-key evil-normal-state-local-map (kbd "l")))
                  (cons "u" (lookup-key evil-normal-state-local-map (kbd "u")))))
      (smerge-mode 1)
      (message "smerge-mode enabled - use SPC g m to exit")
      (evil-local-set-key 'normal (kbd "j") 'smerge-next)
      (evil-local-set-key 'normal (kbd "k") 'smerge-prev)
      (evil-local-set-key 'normal (kbd "l") 'smerge-keep-lower)
      (evil-local-set-key 'normal (kbd "u") 'smerge-keep-upper))))

(map! :leader :desc "Toggle smerge" "g m" #'smerge-mode-toggle)

(defun my-project-root (file)
  "Find the project root from FILE by locating .git and .pre-commit-config.yaml."
  (when-let ((git-root (locate-dominating-file file ".git")))
    (when (file-exists-p (expand-file-name ".pre-commit-config.yaml" git-root))
      git-root)))

;; --- uv workspace venv auto-activation ---
;; uv puts a single .venv at the workspace root; nested workspace members
;; import each other via editable .pth files in that venv. Activating the
;; nearest .venv before LSP starts lets pyright resolve cross-package imports.
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

;; depth -90 so this runs before lsp setup on the mode hooks
(add-hook 'python-mode-hook #'my-uv-venv-activate -90)
(add-hook 'python-ts-mode-hook #'my-uv-venv-activate -90)

;; Belt-and-braces: tell lsp-pyright explicitly where the venv lives,
;; in case it's consulted before VIRTUAL_ENV is read.
(after! lsp-pyright
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
(after! lsp-mode
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

;; clang-format on save for C/C++ only (was c-c++-enable-clang-format-on-save)
(add-hook! '(c-mode-hook c++-mode-hook c-ts-mode-hook c++-ts-mode-hook)
           #'apheleia-mode)

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
(after! dumb-jump
  (setq dumb-jump-selector 'completing-read
        dumb-jump-force-searcher 'rg
        dumb-jump-prefer-searcher 'rg
        dumb-jump-debug nil
        dumb-jump-aggressive t
        dumb-jump-max-find-time 10
        dumb-jump-confirm-jump-to-modified-file nil)
  (add-to-list 'dumb-jump-language-file-exts
               '(:language "python" :ext "py" :agtype "python" :rgtype "py")))

(map! :leader
      (:prefix ("d" . "dumb-jump")
       :desc "Jump to definition" "j" #'dumb-jump-go
       :desc "Jump back" "B" #'dumb-jump-back
       :desc "Jump with prompt" "i" #'dumb-jump-go-prompt
       :desc "Jump other window" "o" #'dumb-jump-go-other-window))

;; claude-code-ide (was the claude-code layer)
(setq claude-code-ide-window-side 'right
      claude-code-ide-window-width 100)

(defvar my_minuet_cli_backend 'claude
  "Authenticated CLI used for inline completions.")

(defun my-minuet-use-claude ()
  "Use Claude Code for inline completions."
  (interactive)
  (setq my_minuet_cli_backend 'claude)
  (message "Inline completions will use Claude Code"))

(defun my-minuet-use-codex ()
  "Use Codex for inline completions."
  (interactive)
  (setq my_minuet_cli_backend 'codex)
  (message "Inline completions will use Codex"))

(defun my-minuet-cli-prompt (context)
  "Build an inline-completion prompt from Minuet CONTEXT."
  (format
   (concat
    "Act as an inline code completion engine. Predict only the text that "
    "belongs at <cursor>. Return exactly the text to insert, with no Markdown "
    "fence, explanation, or surrounding existing code. Do not use tools.\n\n"
    "%s\n<context-before>\n%s\n</context-before>\n"
    "<cursor></cursor>\n<context-after>\n%s\n</context-after>")
   (plist-get context :language-and-tab)
   (plist-get context :before-cursor)
   (plist-get context :after-cursor)))

(defun my-minuet-cli-project-root ()
  "Return the current local project root."
  (when (file-remote-p default-directory)
    (user-error "CLI completions are unavailable in remote buffers"))
  (if-let ((project (project-current nil)))
      (project-root project)
    default-directory))

(defun my-minuet-cli-command (project_root)
  "Build the CLI command for PROJECT_ROOT."
  (pcase my_minuet_cli_backend
    ('claude
     (list (executable-find "claude")
           "--print"
           "--no-session-persistence"
           "--tools" ""))
    ('codex
     (list (executable-find "codex")
           "exec"
           "--ephemeral"
           "--sandbox" "read-only"
           "--color" "never"
           "--skip-git-repo-check"
           "--cd" project_root))
    (_ (user-error "Unknown inline completion backend: %s"
                   my_minuet_cli_backend))))

(defun my-minuet-cli-clean-output (output)
  "Remove CLI framing from completion OUTPUT."
  (let ((text (replace-regexp-in-string "\\r?\\n\\'" "" output)))
    (if (string-match
         "\\````[^\n]*\n\\(\\(?:.\\|\n\\)*\\)\n```[[:space:]]*\\'"
         text)
        (match-string 1 text)
      text)))

(defun minuet--cli-available-p ()
  "Return non-nil when the selected authenticated CLI is installed."
  (executable-find (symbol-name my_minuet_cli_backend)))

(defun minuet--cli-complete (context callback)
  "Request a CLI completion for CONTEXT and pass it to CALLBACK."
  (let* ((target_buffer (current-buffer))
         (project_root (my-minuet-cli-project-root))
         (prompt (my-minuet-cli-prompt context))
         (command (my-minuet-cli-command project_root))
         (stdout_buffer (generate-new-buffer " *minuet-cli-output*"))
         (stderr_buffer (generate-new-buffer " *minuet-cli-errors*"))
         process)
    (message "Minuet: dispatching to %s..." my_minuet_cli_backend)
    (condition-case error_data
        (let ((default-directory project_root))
          (setq process
                (make-process
                 :name (format "minuet-%s" my_minuet_cli_backend)
                 :command command
                 :buffer stdout_buffer
                 :stderr stderr_buffer
                 :coding 'utf-8-unix
                 :connection-type 'pipe
                 :noquery t
                 :sentinel
                 (lambda (finished_process _event)
                   (when (memq (process-status finished_process) '(exit signal))
                     (set-process-sentinel finished_process nil)
                     (when (buffer-live-p target_buffer)
                       (with-current-buffer target_buffer
                         (setq minuet--current-requests
                               (delq finished_process minuet--current-requests))))
                     (unwind-protect
                         (cond
                          ((and (eq (process-status finished_process) 'exit)
                                (zerop (process-exit-status finished_process)))
                           (when (buffer-live-p target_buffer)
                             (let* ((output
                                     (with-current-buffer stdout_buffer
                                       (buffer-string)))
                                    (completion
                                     (my-minuet-cli-clean-output output)))
                               (funcall callback
                                        (unless (string-empty-p completion)
                                          (list completion))))))
                          ((eq (process-status finished_process) 'exit)
                           (let ((error_text
                                  (with-current-buffer stderr_buffer
                                    (string-trim (buffer-string)))))
                             (minuet--log
                              (format "%s CLI failed: %s"
                                      my_minuet_cli_backend
                                      (truncate-string-to-width error_text 500))
                              t)))
                          (t nil))
                       (when (buffer-live-p stdout_buffer)
                         (kill-buffer stdout_buffer))
                       (when (buffer-live-p stderr_buffer)
                         (kill-buffer stderr_buffer)))))))
          (push process minuet--current-requests)
          (process-send-string process prompt)
          (process-send-eof process))
      (error
       (when (buffer-live-p stdout_buffer)
         (kill-buffer stdout_buffer))
       (when (buffer-live-p stderr_buffer)
         (kill-buffer stderr_buffer))
       (signal (car error_data) (cdr error_data))))))

;; Minuet supplies the overlay UI; authenticated CLIs supply completions.
(use-package! minuet
  :bind (("M-i" . #'minuet-show-suggestion)
         :map minuet-active-mode-map
         ("TAB" . #'minuet-accept-suggestion)
         ("<tab>" . #'minuet-accept-suggestion)
         ("M-a" . #'minuet-accept-suggestion-line)
         ("M-w" . #'minuet-accept-suggestion-word)
         ("M-n" . #'minuet-next-suggestion)
         ("M-p" . #'minuet-previous-suggestion)
         ("C-g" . #'minuet-dismiss-suggestion))
  :config
  (setq minuet-provider 'cli
        minuet-n-completions 1))

;; gptel: in-buffer LLM chat/rewrite through the direct Anthropic API.
;; (machine api.anthropic.com login apikey password sk-...)
(use-package! gptel
  :defer t
  :init
  (map! :leader
        (:prefix ("l" . "llm")
         :desc "gptel chat" "l" #'gptel
         :desc "Send region/buffer" "s" #'gptel-send
         :desc "Rewrite region" "r" #'gptel-rewrite
         :desc "Add to context" "a" #'gptel-add
         :desc "Menu" "m" #'gptel-menu
         :desc "Inline completion" "i" #'minuet-show-suggestion
         :desc "Use Claude for inline" "c" #'my-minuet-use-claude
         :desc "Use Codex for inline" "x" #'my-minuet-use-codex))
  :config
  (setq gptel-default-mode 'org-mode
        gptel-model 'claude-opus-5
        gptel-backend (gptel-make-anthropic "Claude" :stream t :key gptel-api-key)))

;; difftastic: structural diffs from magit (needs the difft binary)
(use-package! difftastic
  :defer t
  :init
  (after! magit-diff
    (transient-append-suffix 'magit-diff '(-1 -1)
      [("D" "Difftastic diff (dwim)" difftastic-magit-diff)
       ("S" "Difftastic show" difftastic-magit-show)])))

;; clipboard integration in terminal mode (Wayland)
(unless (display-graphic-p)
  (when (executable-find "wl-copy")
    (setq interprogram-cut-function
          (lambda (text)
            (with-temp-buffer
              (insert text)
              (call-process-region (point-min) (point-max) "wl-copy" nil nil nil))))
    (setq interprogram-paste-function
          (lambda ()
            (with-temp-buffer
              (call-process "wl-paste" nil t nil "--no-newline")
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
(use-package! mpv
  :defer t
  :init
  (map! :leader
        :desc "Play video (mpv)" "a v" #'mpv-play-tramp-aware
        :desc "Kill mpv" "a V" #'mpv-kill)
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
      (mpv-play-tramp-aware file))))

(after! dired
  (define-key dired-mode-map (kbd "v") 'mpv-play-video-at-point))
