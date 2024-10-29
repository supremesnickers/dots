;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Duc Hoang Seidel"
      user-mail-address "hoangseidel02@gmail.com")

;; THEMING
;;
(setq doom-font (font-spec :family "SFMono Nerd Font" :size 12 :weight 'regular)
      doom-big-font (font-spec :family "SFMono Nerd Font" :size 22 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Helvetica Neue" :size 14 :weight 'regular)
)
(setq mine/light-theme 'doom-one-light)
(setq mine/dark-theme 'doom-badger)
(setq doom-themes-enable-bold nil
      doom-themes-padded-modeline 3
      doom-acario-light-brighter-modeline t)

;; (setq modus-themes-common-palette-overrides
;;       '((fringe unspecified)
;;         (bg-mode-line-active "#f0f0f0")
;;         (border-mode-line-active bg-mode-line-inactive)
;;         (border-mode-line-inactive bg-mode-line-active)
;;         ))

;; (setq ef-themes-common-palette-overrides
;;       '((bg-mode-line "#ececec")))

;; Auto-switching theme according to system preference
;;
;; taken from https://www.reddit.com/r/emacs/comments/o49v2w/comment/i5ibcyv
(defun mine/apply-theme (value)
  "Set the appropiate theme according to the color-scheme setting value."
  (if IS-LINUX
      (if (equal value '1)
          (consult-theme mine/dark-theme)
        (consult-theme mine/light-theme))
  (progn
    (mapc #'disable-theme custom-enabled-themes)
    (pcase value
      ('light (consult-theme mine/light-theme))
      ('dark (consult-theme mine/dark-theme))))))

(defun mine/color-scheme-changed (path var value)
  "DBus handler to detect when the color-scheme has changed."
  (when (and (string-equal path "org.freedesktop.appearance")
             (string-equal var "color-scheme"))
    (mine/apply-theme (car value))))

(if IS-LINUX
    (progn
      (autoload 'dbus-register-signal "dbus")
      (autoload 'dbus-call-method-asynchronously "dbus")

      ;; Register for future changes
      (dbus-register-signal
       :session "org.freedesktop.portal.Desktop"
       "/org/freedesktop/portal/desktop" "org.freedesktop.portal.Settings"
       "SettingChanged"
       #'mine/color-scheme-changed)

      ;; Request the current color-scheme
      (dbus-call-method-asynchronously
       :session "org.freedesktop.portal.Desktop"
       "/org/freedesktop/portal/desktop" "org.freedesktop.portal.Settings"
       "Read"
       (lambda (value) (mine/set-theme-from-dbus-value (caar value)))
       "org.freedesktop.appearance"
       "color-scheme"
       ))
  (add-hook 'ns-system-appearance-change-functions #'mine/apply-theme))

(setq undo-limit 80000000              ; Raise undo-limit to 80Mb
      undo-fu-allow-undo-in-region t   ; More selective undo
      auto-save-default t              ; Nobody likes to loose work, I certainly don't
      inhibit-compacting-font-caches t ; When there are lots of glyphs, keep them in memory
      truncate-string-ellipsis "…")    ; Unicode ellispis are nicer than "...", and also save /precious/ space

;; startup splash screen
(setq fancy-splash-image (concat doom-user-dir "banners/emacs.png"))

;; Hide minor modes in modeline in submenu
(setq minions-mode-line-lighter "…"
      minions-mode-line-delimiters '("(" . ")"))

(add-hook 'after-change-major-mode-hook 'minions-mode)

(setq scroll-margin 0)

;; hide-cursor-mode
;; https://karthinks.com/software/more-less-emacs/
(defvar-local hide-cursor--original nil)

(define-minor-mode hide-cursor-mode
  "Hide or show the cursor.

When the cursor is hidden `scroll-lock-mode' is enabled, so that
the buffer works like a pager."
  :global nil
  :lighter "H"
  (if hide-cursor-mode
      (progn
        (scroll-lock-mode 1)
        (hl-line-mode -1)
        (setq-local hide-cursor--original
                    cursor-type)
        (setq-local cursor-type nil))

    (scroll-lock-mode -1)
    (hl-line-mode 1)
    (setq-local cursor-type (or hide-cursor--original
                                t))))

(add-hook! 'Man-mode-hook  #'hide-cursor-mode)
(add-hook! 'Info-mode-hook #'hide-cursor-mode)

(column-number-mode 1)

;; Code
(setq display-line-numbers-type t)
(setq global-prettify-symbols-mode nil)
(global-tree-sitter-mode 1)
;; enable treesitter based folding whenever treesitter is on
(global-ts-fold-mode 1)
;; (global-ts-fold-indicators-mode 1)

;; associate .ui files with xml type
(add-to-list 'auto-mode-alist '("\\.ui\\'" . xml-mode))

;; Enable ccls for all c++ files, and platformio-mode only
;; when needed (platformio.ini present in project root).
;; (add-hook 'c++-mode-hook (lambda ()
;;                            (lsp-deferred)
;;                            (platformio-conditionally-enable)))

(add-to-list '+cc-default-compiler-options '(c++-mode "-std=c++17"))

(breadcrumb-mode 1)

(setq tab-width 2)

(map! "M-Z" #'zzz-to-char)

;; add treesitter node expansion to expand-region
;; taken from https://github.com/emacs-tree-sitter/elisp-tree-sitter/issues/20
(defun tree-sitter-mark-bigger-node ()
  "Uses tree-sitter to provide the next AST node to expand the region to"
  (interactive)
  (let* ((root (tsc-root-node tree-sitter-tree))
         (node (tsc-get-descendant-for-position-range root (region-beginning) (region-end)))
         (node-start (tsc-node-start-position node))
         (node-end (tsc-node-end-position node)))
    ;; Node fits the region exactly. Try its parent node instead.
    (when (and (= (region-beginning) node-start) (= (region-end) node-end))
      (when-let ((node (tsc-get-parent node)))
        (setq node-start (tsc-node-start-position node)
              node-end (tsc-node-end-position node))))
    (set-mark node-end)
    (goto-char node-start)))

(after! expand-region
  (setq er/try-expand-list (append er/try-expand-list
                                   '(tree-sitter-mark-bigger-node))))
;; COMPLETION
;; use vertico multiform to have a different prompt for different uses
;; (setq vertico-multiform-categories '((file flat)
;;                                      (consult-grep buffer))
;;       vertico-multiform-commands '((execute-extended-command flat)
;;                                    (consult-recent-file indexed)))
;; (vertico-multiform-mode)
;; improve completion by having the first word match like the initial,
;; later components (separated by space) ending with ~ are matched in
;; the flex style (fuzzy)
;; taken from https://github.com/oantolin/orderless#style-dispatchers
(defun flex-if-twiddle (pattern _index _total)
  (when (string-suffix-p "~" pattern)
    `(orderless-flex . ,(substring pattern 0 -1))))

(defun first-initialism (pattern index _total)
  (if (= index 0) 'orderless-initialism))

(defun without-if-bang (pattern _index _total)
  (cond
   ((equal "!" pattern)
    '(orderless-literal . ""))
   ((string-prefix-p "!" pattern)
    `(orderless-without-literal . ,(substring pattern 1)))))

;; (setq orderless-matching-styles '(orderless-regexp)
;;       orderless-style-dispatchers '(first-initialism
;;                                     flex-if-twiddle
;;                                     without-if-bang))

(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; KEYBINDINGS
;;
(after! avy
  ;; home row priorities: 8 6 4 5 - - 1 2 3 7
  (setq avy-keys '(?n ?e ?o ?i ?t ?h ?s ?a)
        avy-all-windows t
        avy-timeout-seconds 0.3
        avy-single-candidate-jump t
        avy-all-windows-alt nil))

(map! "C-\'" #'avy-goto-char-timer
      "C-\"" #'avy-goto-char-2
      "C-{"  #'avy-goto-line-above
      "C-}"  #'avy-goto-line-below)

(map! "C-." #'mc/mark-next-like-this
      "C-," #'mc/mark-previous-like-this
      "C->" #'mc/unmark-previous-like-this
      "C-<" #'mc/unmark-next-like-this)

;; (map! "mouse-8" #'previous-buffer
;;       "mouse-9" #'next-buffer)

(map! :desc "Hide cursor mode" "C-c t C" #'hide-cursor-mode
      :desc "Open Eshell" "C-c o e" #'eshell)

;; casual-calc
(keymap-set calc-mode-map "C-o" #'casual-calc-tmenu)
(keymap-set calc-alg-map "C-o" #'casual-calc-tmenu)

(defun scroll-up-half ()
  (interactive)
  (scroll-up-command
   (floor
    (- (window-height)
       next-screen-context-lines)
    2)))

(defun scroll-down-half ()
  (interactive)
  (scroll-down-command
   (floor
    (- (window-height)
       next-screen-context-lines)
    2)))

;; (map! "C-v" #'scroll-down-half
;;       "M-v" #'scroll-up-half)

;; BEHAVIOUR
;;
;; (set-popup-rule! "^*compilation*" :quit 'current :select nil :height 0.3)
(set-popup-rules! '(("^*compilation*" :quit 'current :select nil :height 0.3 :modeline t)
                    ("^\\*Calc" :select 1 :height 0.8)))

;; enables result count in incremental search
(setq isearch-lazy-count t
      lazy-count-prefix-format nil
      lazy-count-suffix-format "   (%s/%s)")

;; CTRLF
;; (ctrlf-mode 1)

(use-package! promela-mode
  :mode ("\\.pml$" . promela-mode))

;; ORG-MODE
;;
(setq org-directory "~/Documents/")

;; DIRED
;;
(setq dired-free-space nil
      dired-listing-switches "-AGFhl -v --group-directories-first")

(setq dgi-commit-message-format "%h %cs %s")

;; (add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; DWIM commands
(defun increment-integer-at-point (&optional inc)
  "Increment integer at point by one.

With numeric prefix arg INC, increment the integer by INC amount."
  (interactive "p")
  (let ((inc (or inc 1))
        (n (thing-at-point 'integer))
        (bounds (bounds-of-thing-at-point 'integer)))
    (delete-region (car bounds) (cdr bounds))
    (insert (int-to-string (+ n inc)))))

(defun decrement-integer-at-point (&optional dec)
  "Decrement integer at point by one.

With numeric prefix arg DEC, decrement the integer by DEC amount."
  (interactive "p")
  (increment-integer-at-point (- (or dec 1))))

;; eshell
(defun eshell/z (&optional regexp)
    "Navigate to a previously visited directory in eshell, or to
any directory proferred by `consult-dir'."
    (let ((eshell-dirs (delete-dups
                        (mapcar 'abbreviate-file-name
                                (ring-elements eshell-last-dir-ring)))))
      (cond
       ((and (not regexp) (featurep 'consult-dir))
        (let* ((consult-dir--source-eshell `(:name "Eshell"
                                             :narrow ?e
                                             :category file
                                             :face consult-file
                                             :items ,eshell-dirs))
               (consult-dir-sources (cons consult-dir--source-eshell
                                          consult-dir-sources)))
          (eshell/cd (substring-no-properties
                      (consult-dir--pick "Switch directory: ")))))
       (t (eshell/cd (if regexp (eshell-find-previous-directory regexp)
                            (completing-read "cd: " eshell-dirs)))))))

;; MACROS
(defalias 'align-comments-in-region
   (kmacro "C-u M-x <return> ; SPC <return> <return> <backspace> 5 <return> y"))
