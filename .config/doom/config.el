;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Hoang Seidel"
      user-mail-address "hoangseidel02@gmail.com")

;; THEMING
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 14 :weight 'regular)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 22 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Inter" :size 17 :weight 'regular))

(setq mine/light-theme 'modus-operandi)
(setq mine/dark-theme 'kaolin-dark)
(setq doom-themes-enable-bold nil)

(setq modus-themes-common-palette-overrides
      '((fringe unspecified)
        (bg-mode-line-active "#f0f0f0")
        ;; (border-mode-line-active "#eeeeee")
        ;; (border-mode-line-inactive "#eeeeee")
        ))

(setq ef-themes-common-palette-overrides
      '((bg-mode-line "#ececec")))

;; set Emacs according to system preference, auto-switches on the theme change
;; taken from https://www.reddit.com/r/emacs/comments/o49v2w/comment/i5ibcyv
(defun mine/set-theme-from-dbus-value (value)
  "Set the appropiate theme according to the color-scheme setting value."
  (if (equal value '1)
      (consult-theme mine/dark-theme)
    (consult-theme mine/light-theme)))

(defun mine/color-scheme-changed (path var value)
  "DBus handler to detect when the color-scheme has changed."
  (when (and (string-equal path "org.freedesktop.appearance")
             (string-equal var "color-scheme"))
    (mine/set-theme-from-dbus-value (car value))))

(require 'dbus)

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
 )

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      inhibit-compacting-font-caches t            ; When there are lots of glyphs, keep them in memory
      truncate-string-ellipsis "…")                    ; Unicode ellispis are nicer than "...", and also save /precious/ space

;; startup splash screen
(setq fancy-splash-image (concat doom-user-dir "banners/emacs.png"))

;; Hide minor modes in modeline in submenu
(setq minions-mode-line-lighter "…")
(add-hook 'after-change-major-mode-hook 'minions-mode)

;; Code
(setq display-line-numbers-type t)
(setq global-prettify-symbols-mode nil)
(global-tree-sitter-mode 1)

(setq tab-width 2)

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
;;
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

(setq orderless-matching-styles '(orderless-regexp)
      orderless-style-dispatchers '(first-initialism
                                    flex-if-twiddle
                                    without-if-bang))

(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; KEYBINDINGS
;;
(after! avy
  ;; home row priorities: 8 6 4 5 - - 1 2 3 7
  (setq avy-keys '(?n ?e ?o ?i ?t ?h ?s ?a)))

(map! "C-\'" #'avy-goto-char-timer)

(map! "C-." #'mc/mark-next-like-this
      "C-," #'mc/mark-previous-like-this
      "C->" #'mc/unmark-previous-like-this
      "C-<" #'mc/unmark-next-like-this)

;; (map! "mouse-8" #'previous-buffer
;;       "mouse-9" #'next-buffer)

;; ORG-MODE
;;
(setq org-directory "~/Documents/org/")
