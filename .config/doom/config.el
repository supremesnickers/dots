;;; config.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; This configuration file sets up various packages and customizations for Emacs.

;;; Code:

;; Personal Information
(setq user-full-name "Duc Hoang Seidel"
      user-mail-address "hoangseidel02@gmail.com")

;; Theming and Visual Settings
(setq doom-font (font-spec :family "SFMono Nerd Font" :size 12 :weight 'regular)
      doom-big-font (font-spec :family "SFMono Nerd Font" :size 22 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Helvetica Neue" :size 14 :weight 'regular))

(setq listen-directory "/Users/hoang/Music/Music/Media.localized/Music")

(setq mine/light-theme 'doom-one-light)
(setq mine/dark-theme 'doom-badger)
(setq doom-themes-enable-bold nil
      doom-themes-padded-modeline 3
      doom-acario-light-brighter-modeline t)

;; Auto-switching theme according to system preference
(defun mine/apply-theme (value)
  "Set the appropriate theme according to the color-scheme setting VALUE."
      (if (equal value '1)
          (consult-theme mine/dark-theme)
        (consult-theme mine/light-theme))
    (progn
      (mapc #'disable-theme custom-enabled-themes)
      (pcase value
        ('light (consult-theme mine/light-theme))
        ('dark (consult-theme mine/dark-theme)))))

(defun mine/color-scheme-changed (path var value)
  "DBus handler to detect when the color-scheme has changed."
  (when (and (string-equal path "org.freedesktop.appearance")
             (string-equal var "color-scheme"))
    (mine/apply-theme (car value))))

;; Set up auto-switching theme for Linux and macOS
(if IS-LINUX
    (progn
      (autoload 'dbus-register-signal "dbus")
      (autoload 'dbus-call-method-asynchronously "dbus")
      (dbus-register-signal
       :session "org.freedesktop.portal.Desktop"
       "/org/freedesktop/portal/desktop" "org.freedesktop.portal.Settings"
       "SettingChanged"
       #'mine/color-scheme-changed)
      (dbus-call-method-asynchronously
       :session "org.freedesktop.portal.Desktop"
       "/org/freedesktop/portal/desktop" "org.freedesktop.portal.Settings"
       "Read"
       (lambda (value) (mine/set-theme-from-dbus-value (caar value)))
       "org.freedesktop.appearance"
       "color-scheme"))
  (add-hook 'ns-system-appearance-change-functions #'mine/apply-theme))

;; General Settings
(setq undo-limit 80000000              ; Raise undo-limit to 80Mb
      undo-fu-allow-undo-in-region t   ; More selective undo
      auto-save-default t              ; Nobody likes to loose work, I certainly don't
      inhibit-compacting-font-caches t ; When there are lots of glyphs, keep them in memory
      truncate-string-ellipsis "…")    ; Unicode ellispis are nicer than "...", and also save /precious/ space

;; Startup and UI Settings
(setq fancy-splash-image (concat doom-user-dir "banners/emacs.png"))
(setq minions-mode-line-lighter "…"
      minions-mode-line-delimiters '("(" . ")"))
(add-hook 'after-change-major-mode-hook 'minions-mode)
(setq scroll-margin 0)

;; Hide-cursor-mode
;; https://karthinks.com/software/more-less-emacs/
(defvar-local hide-cursor--original nil)
(define-minor-mode hide-cursor-mode
  "Hide or show the cursor. When hidden, enable `scroll-lock-mode'."
  :global nil
  :lighter "H"
  (if hide-cursor-mode
      (progn
        (scroll-lock-mode 1)
        (hl-line-mode -1)
        (setq-local hide-cursor--original cursor-type)
        (setq-local cursor-type nil))
    (scroll-lock-mode -1)
    (hl-line-mode 1)
    (setq-local cursor-type (or hide-cursor--original t))))

(add-hook! 'Man-mode-hook #'hide-cursor-mode)
(add-hook! 'Info-mode-hook #'hide-cursor-mode)

;; Code and Syntax Settings
(setq display-line-numbers-type t)
(setq global-prettify-symbols-mode nil)
(global-tree-sitter-mode 1)
(global-ts-fold-mode 1)
(add-to-list 'auto-mode-alist '("\\.ui\\'" . xml-mode))
;; (add-to-list '+cc-default-compiler-options '(c++-mode "-std=c++11"))
;; (breadcrumb-mode 1)
(setq tab-width 2)

;; Keybindings
(map! "M-Z" #'zzz-to-char)
(map! "C-\'" #'avy-goto-char-timer
      "C-\"" #'avy-goto-char-2
      "C-{" #'avy-goto-line-above
      "C-}" #'avy-goto-line-below)
(map! "C-." #'mc/mark-next-like-this
      "C-," #'mc/mark-previous-like-this
      "C->" #'mc/unmark-previous-like-this
      "C-<" #'mc/unmark-next-like-this)
(map! :desc "Hide cursor mode" "C-c t C" #'hide-cursor-mode
      :desc "Open Eshell" "C-c o e" #'eshell)

;; Custom Functions
(defun scroll-up-half ()
  "Scroll up half a screen."
  (interactive)
  (scroll-up-command
   (floor
    (- (window-height)
       next-screen-context-lines)
    2)))

(defun scroll-down-half ()
  "Scroll down half a screen."
  (interactive)
  (scroll-down-command
   (floor
    (- (window-height)
       next-screen-context-lines)
    2)))

;; Popup Rules
(set-popup-rules!
 '(("^*compilation*" :quit 'current :select nil :height 0.3 :modeline t)
   ("^\\*Calc" :select 1 :height 0.8)))

;; Search Settings
(setq isearch-lazy-count t
      lazy-count-prefix-format nil
      lazy-count-suffix-format " (%s/%s)")

;; Org-mode Settings
(setq org-directory "~/Documents/")

;; Dired Settings
(setq dired-free-space nil
      dired-listing-switches "-AGFhl -v --group-directories-first")
(setq dgi-commit-message-format "%h %cs %s")

;; Custom Functions
(defun increment-integer-at-point (&optional inc)
  "Increment integer at point by INC (default 1)."
  (interactive "p")
  (let ((inc (or inc 1))
        (n (thing-at-point 'integer))
        (bounds (bounds-of-thing-at-point 'integer)))
    (delete-region (car bounds) (cdr bounds))
    (insert (int-to-string (+ n inc)))))

(defun decrement-integer-at-point (&optional dec)
  "Decrement integer at point by DEC (default 1)."
  (interactive "p")
  (increment-integer-at-point (- (or dec 1))))

;; Eshell Functions
(defun eshell/z (&optional regexp)
  "Navigate to a previously visited directory in eshell, or to any directory offered by `consult-dir'."
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

;; Macros
(defalias 'align-comments-in-region
  (kmacro "C-u M-x ; SPC 5 y"))

(provide 'config)
;;; config.el ends here
