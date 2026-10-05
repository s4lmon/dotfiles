(require 'autorevert)
(require 'diff)
(require 'seq)

(defgroup external-changes nil
  "Mark file changes made outside Emacs until they have been read."
  :group 'files)

(defcustom external-changes-contiguous-read t
  "Clear a whole changed block when the cursor enters it.
When nil, clear only the line the cursor enters."
  :type 'boolean
  :group 'external-changes)

(defface external-changes-unread
  '((((class color) (background dark)) :background "#663b16" :extend t)
    (((class color) (background light)) :background "#ffd6a3" :extend t)
    (t :inverse-video t))
  "Orange background for unread external changes."
  :group 'external-changes)

(defvar-local external-changes--overlays nil)

(defun external-changes--mark (start end &optional deleted)
  (let ((removed (when deleted (list (cons start deleted)))))
    (when external-changes-contiguous-read
      (dolist (overlay external-changes--overlays)
        (when (and (overlay-buffer overlay)
                   (<= (overlay-start overlay) end)
                   (>= (overlay-end overlay) start))
          (when-let* ((text (overlay-get overlay 'external-changes-deleted)))
            (push (cons (overlay-start overlay) text) removed))
          (setq start (min start (overlay-start overlay))
                end (max end (overlay-end overlay)))
          (delete-overlay overlay)))
      (setq external-changes--overlays
            (seq-filter #'overlay-buffer external-changes--overlays)))
    (let ((overlay (make-overlay start end nil nil t)))
      (overlay-put overlay 'face 'external-changes-unread)
      (overlay-put overlay 'priority 20)
      (overlay-put overlay 'help-echo "Changed outside Emacs")
      (when removed
        (setq deleted
              (mapconcat #'cdr (sort removed (lambda (a b) (< (car a) (car b)))) ""))
        (overlay-put overlay 'external-changes-deleted deleted)
        (overlay-put overlay 'before-string
                     (propertize
                      (concat (if (and (> start (point-min))
                                       (/= (char-before start) ?\n)) "\n" "")
                              deleted)
                      'face 'external-changes-unread)))
      (push overlay external-changes--overlays))))

(defun external-changes--highlight (before)
  "Mark the changed blocks between BEFORE and the current buffer."
  (let ((target (current-buffer))
        (output (generate-new-buffer " *external changes diff*"))
        (diff-entire-buffers t)
        hunks)
    (unwind-protect
        (progn
          (with-temp-buffer
            (insert before)
            (diff-no-select (current-buffer) target '("-U0") t output))
          (with-current-buffer output
            (goto-char (point-min))
            (while (re-search-forward
                    "^@@ -[0-9]+\\(?:,[0-9]+\\)? \\+\\([0-9]+\\)\\(?:,\\([0-9]+\\)\\)? @@"
                    nil t)
              (let ((line (string-to-number (match-string 1)))
                    (count (if (match-string 2) (string-to-number (match-string 2)) 1))
                    removed)
                (forward-line 1)
                (while (looking-at "[-+\\\\]")
                  (when (looking-at "-")
                    (push (concat "- "
                                  (buffer-substring-no-properties
                                   (1+ (point)) (line-end-position))
                                  "\n")
                          removed))
                  (forward-line 1))
                (push (list line count (when removed (apply #'concat (nreverse removed))))
                      hunks))))
          (save-excursion
            (save-restriction
              (widen)
              (pcase-dolist (`(,line ,count ,deleted) hunks)
                (goto-char (point-min))
                (if (zerop count)
                    (progn
                      (forward-line line)
                      (external-changes--mark (point) (point) deleted))
                  (forward-line (1- line))
                  (if external-changes-contiguous-read
                      (let ((start (point)))
                        (forward-line count)
                        (external-changes--mark start (point) deleted))
                    (dotimes (index count)
                      (let ((start (point)))
                        (forward-line 1)
                        (external-changes--mark start (point) (when (zerop index) deleted))))))))))
      (kill-buffer output))))

(defun external-changes--auto-revert (original &rest args)
  "Highlight external edits without changing how unsaved buffers are handled."
  (if (or (not buffer-file-name) (buffer-modified-p))
      (apply original args)
    (save-restriction
      (widen)
      (let ((before (buffer-substring-no-properties (point-min) (point-max)))
            (tick (buffer-chars-modified-tick))
            (revert-buffer-insert-file-contents-function
             #'revert-buffer-insert-file-contents-delicately))
        (prog1 (apply original args)
          (unless (= tick (buffer-chars-modified-tick))
            (external-changes--highlight before)))))))

(defun external-changes--read-at-point ()
  "Clear unread highlights touched by the cursor."
  (setq external-changes--overlays
        (delq nil
              (mapcar
               (lambda (overlay)
                 (when (overlay-buffer overlay)
                   (if (and (<= (overlay-start overlay) (point))
                            (or (< (point) (overlay-end overlay))
                                (= (overlay-start overlay) (overlay-end overlay))))
                       (progn (delete-overlay overlay) nil)
                     overlay)))
               external-changes--overlays))))

(define-minor-mode external-changes-mode
  "Keep external edits orange until the cursor visits them."
  :global t
  :group 'external-changes
  (if external-changes-mode
      (progn
        (advice-add 'auto-revert-handler :around #'external-changes--auto-revert)
        (add-hook 'pre-command-hook #'external-changes--read-at-point)
        (add-hook 'post-command-hook #'external-changes--read-at-point))
    (advice-remove 'auto-revert-handler #'external-changes--auto-revert)
    (remove-hook 'pre-command-hook #'external-changes--read-at-point)
    (remove-hook 'post-command-hook #'external-changes--read-at-point)
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (mapc #'delete-overlay external-changes--overlays)
        (setq external-changes--overlays nil)))))

(provide 'external-changes)
