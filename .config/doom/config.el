;; [[file:config.org::*Main configuration][Main configuration:1]]
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; Main configuration:1 ends here

;; [[file:config.org::*Personal information][Personal information:1]]
(setq user-full-name "Hoang Seidel"
      user-mail-address "hoangseidel02@gmail.com")
;; Personal information:1 ends here

;; [[file:config.org::*Simple settings][Simple settings:1]]
(add-hook 'emacs-startup-hook 'toggle-frame-maximized 100) ; startup emacs maximized

(setq comp-async-report-warnings-errors nil)

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 tab-width 2                                      ; Set width for tabs
 uniquify-buffer-name-style 'forward              ; Uniquify buffer names
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(global-undo-tree-mode)

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      inhibit-compacting-font-caches t            ; When there are lots of glyphs, keep them in memory
      truncate-string-ellipsis "…")               ; Unicode ellispis are nicer than "...", and also save /precious/ space

;; (delete-selection-mode 1)                         ; Replace selection when inserting text

(when IS-LINUX
  (doom-load-envvars-file "~/.config/doom/fedora.env")
  (after! core-ui
    (menu-bar-mode -1)))

(when IS-MAC
  (setenv "PATH" (concat (getenv "PATH") ":/Library/TeX/texbin/"))
  (setenv "LANG" "en_US.UTF-8")
  (setq exec-path (append exec-path '("/Library/TeX/texbin/")))
  ;; Use Command key as Meta and Option key for compose sequences
  (setq mac-command-modifier 'meta)
  (setq mac-option-key-is-meta nil))

(setq +latex-viewers '(pdf-tools))

(global-subword-mode 1)                           ; Iterate through CamelCase words
;; Simple settings:1 ends here

;; [[file:config.org::*Customize interface][Customize interface:1]]
(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))
;; Customize interface:1 ends here

(if IS-LINUX
    (setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 14 :weight 'regular)
          doom-big-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 22 :weight 'regular)
          doom-variable-pitch-font (font-spec :family "Inter" :size 17 :weight 'regular))

  (setq doom-font (font-spec :family "IBM Plex Mono" :size 14 :height 1.1)
        doom-big-font (font-spec :family "IBM Plex Mono" :size 22 :height 1.1)
        doom-variable-pitch-font (font-spec :family "Overpass" :size 14 :weight 'regular)
        doom-unicode-font (font-spec :family "FontAwesome" :size 14 :weight 'regular)))

(setq doom-themes-treemacs-enable-variable-pitch nil)

;; bigger characters when selecting windows with avy
;; (custom-set-faces!
;;   '(aw-leading-char-face
;;     :foreground "white" :background "red"
;;     :weight bold :height 2.5 :box (:line-width 10 :color "red")))

(after! doom-theme
(setq kaolin-themes-bold t        ; If nil, disable the bold style.
      kaolin-themes-italic t      ; If nil, disable the italic style.
      kaolin-themes-underline t ; If nil, disable the underline style.
      kaolin-themes-italic-comments t
      kaolin-themes-hl-line-colored t
      kaolin-themes-distinct-company-scrollbar t
      kaolin-themes-git-gutter-solid t))

(when IS-MAC
(defun my/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (counsel-load-theme-action "doom-nord-light"))
    ('dark (counsel-load-theme-action "doom-nord"))))

(add-hook 'ns-system-appearance-change-functions 'my/apply-theme))

(when IS-LINUX
;; (setq doom-theme 'zaiste)
(let ((gtk-theme (downcase
                  (cdr (doom-call-process "gsettings"
                                          "get"
                                          "org.gnome.desktop.interface"
                                          "gtk-theme")))))
  (if (or (string-match-p "dark" gtk-theme)
          (string-match-p "black" gtk-theme))
      (setq doom-theme 'doom-tomorrow-night)
    (setq doom-theme 'doom-tomorrow-day))))

(setq all-the-icons-scale-factor 1.1)
(setq doom-modeline-icon (display-graphic-p)     ; show icon in modeline if in GUI
    doom-modeline-buffer-encoding nil
    doom-modeline-modal-icon t
    doom-modeline-height 30
    doom-modeline-major-mode-icon t
    doom-modeline-major-mode-color-icon t
    ;; doom-modeline-buffer-file-name-style 'truncate-upto-project
    doom-modeline-bar-width 1
    doom-modeline-irc t
    doom-modeline-mu4e t
    doom-modeline-enable-word-count nil)

(setq display-time-format "%a %e. %b %H:%M")
(setq display-time-default-load-average nil)

(after! doom-modeline (display-time-mode 1))                             ; Enable time in the mode-line

;; (mu4e-alert-enable-mode-line-display)

;; (doom-modeline-def-modeline 'my-simple-line
;;   '(matches buffer-info remote-host buffer-position selection-info)
;;   '(misc-info minor-modes input-method buffer-encoding mu4e major-mode process vcs checker))

;; Add to `doom-modeline-mode-hook` or other hooks
;; (defun setup-custom-doom-modeline ()
;;   (doom-modeline-set-modeline 'my-simple-line 'default))

;; (add-hook 'doom-modeline-mode-hook 'setup-custom-doom-modeline)
;; (setq global-mode-string (cons (async-start (shell-command-to-string "osascript -l JavaScript ~/dotfiles/tmux/.config/tmux/tunes.js")) global-mode-string)) ;; TODO

;; (setq fancy-splash-image "~/.config/doom/banners/doom-emacs-0.2.ai")

(setq display-line-numbers-type t)

;; [[file:config.org::*Miscellaneous][Miscellaneous:3]]
;; (setq highlight-indent-guides-mode 'character)
;; (setq highlight-indent-guides-character ?→)
;; (setq highlight-indent-guides-delay 0.5)
;; (setq highlight-indent-guides-auto-character-face-perc 20)
;; Miscellaneous:3 ends here

;; [[file:config.org::*Miscellaneous][Miscellaneous:4]]
(nav-flash-show)
;; Miscellaneous:4 ends here

(after! avy
;; home row priorities: 8 6 4 5 - - 1 2 3 7
(setq avy-keys '(?n ?e ?o ?h ?t ?s ?i ?a)))

;; [[file:config.org::*Org mode][Org mode:1]]
(map! :leader
    ;; :n "SPC" #'counsel-M-x
    :n ";"   #'pp-eval-expression)
(set-register ?o (cons 'file "~/org/index.org"))
;; Org mode:1 ends here

;; [[file:config.org::*Org mode][Org mode:2]]
;; (use-package! doct
;;   :hook (o)
;;   :commands (doct))

;; (after! org-capture
;;   ;; <<prettify-capture>>
;;   (setq +org-capture-uni-units (split-string (f-read-text "~/org/uni-units.org")))
;;   ;; (setq +org-capture-recipies  "~/Desktop/TEC/Organisation/recipies.org")

;;   (defun +doct-icon-declaration-to-icon (declaration)
;;     "Convert :icon declaration to icon"
;;     (let ((name (pop declaration))
;;           (set  (intern (concat "all-the-icons-" (plist-get declaration :set))))
;;           (face (intern (concat "all-the-icons-" (plist-get declaration :color))))
;;           (v-adjust (or (plist-get declaration :v-adjust) 0.01)))
;;       (apply set `(,name :face ,face :v-adjust ,v-adjust))))

;;   (defun +doct-iconify-capture-templates (groups)
;;     "Add declaration's :icon to each template group in GROUPS."
;;     (let ((templates (doct-flatten-lists-in groups)))
;;       (setq doct-templates (mapcar (lambda (template)
;;                                      (when-let* ((props (nthcdr (if (= (length template) 4) 2 5) template))
;;                                                  (spec (plist-get (plist-get props :doct) :icon)))
;;                                        (setf (nth 1 template) (concat (+doct-icon-declaration-to-icon spec)
;;                                                                       "\t"
;;                                                                       (nth 1 template))))
;;                                      template)
;;                                    templates))))

;;   (setq doct-after-conversion-functions '(+doct-iconify-capture-templates))

;;   (add-transient-hook! 'org-capture-select-template
;;     (setq org-capture-templates
;;           (doct `(("Personal todo" :keys "t"
;;                    :icon ("checklist" :set "octicon" :color "green")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Inbox"
;;                    :type entry
;;                    :template ("* TODO %?"
;;                               "%i %a")
;;                    )
;;                   ("Personal note" :keys "n"
;;                    :icon ("sticky-note-o" :set "faicon" :color "green")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Inbox"
;;                    :type entry
;;                    :template ("* %?"
;;                               "%i %a")
;;                    )
;;                   ;; ("University" :keys "u"
;;                   ;;  :icon ("graduation-cap" :set "faicon" :color "purple")
;;                   ;;  :file +org-capture-todo-file
;;                   ;;  :headline "University"
;;                   ;;  :unit-prompt ,(format "%%^{Unit|%s}" (string-join +org-capture-uni-units "|"))
;;                   ;;  :prepend t
;;                   ;;  :type entry
;;                   ;;  :children (("Test" :keys "t"
;;                   ;;              :icon ("timer" :set "material" :color "red")
;;                   ;;              :template ("* TODO [#C] %{unit-prompt} %? :uni:tests:"
;;                   ;;                         "SCHEDULED: %^{Test date:}T"
;;                   ;;                         "%i %a"))
;;                   ;;             ("Assignment" :keys "a"
;;                   ;;              :icon ("library_books" :set "material" :color "orange")
;;                   ;;              :template ("* TODO [#B] %{unit-prompt} %? :uni:assignments:"
;;                   ;;                         "DEADLINE: %^{Due date:}T"
;;                   ;;                         "%i %a"))
;;                   ;;             ("Lecture" :keys "l"
;;                   ;;              :icon ("keynote" :set "fileicon" :color "orange")
;;                   ;;              :template ("* TODO [#C] %{unit-prompt} %? :uni:lecture:"
;;                   ;;                         "%i %a"))
;;                   ;;             ("Miscellaneous task" :keys "u"
;;                   ;;              :icon ("list" :set "faicon" :color "yellow")
;;                   ;;              :template ("* TODO [#D] %{unit-prompt} %? :uni:"
;;                   ;;                         "%i %a"))))
;;                   ;; ("Email" :keys "e"
;;                   ;;  :icon ("envelope" :set "faicon" :color "blue")
;;                   ;;  :file +org-capture-todo-file
;;                   ;;  :prepend t
;;                   ;;  :headline "Inbox"
;;                   ;;  :type entry
;;                   ;;  :template ("* TODO %^{type|reply to|contact} %\\3 %? :email:"
;;                   ;;             "Send an email %^{urgency|soon|ASAP|anon|at some point|eventually} to %^{recipiant}"
;;                   ;;             "about %^{topic}"
;;                   ;;             "%U %i %a"))
;;                   ("Interesting" :keys "i"
;;                    :icon ("eye" :set "faicon" :color "lcyan")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Interesting"
;;                    :type entry
;;                    :template ("* [ ] %{desc}%? :%{i-type}:"
;;                               "%i %a")
;;                    :children (("Webpage" :keys "w"
;;                                :icon ("globe" :set "faicon" :color "green")
;;                                :desc "%(org-cliplink-capture) "
;;                                :i-type "read:web"
;;                                )
;;                               ("Article" :keys "a"
;;                                :icon ("file-text" :set "octicon" :color "yellow")
;;                                :desc ""
;;                                :i-type "read:reaserch"
;;                                )
;;                               ;; ("\tRecipie" :keys "r"
;;                               ;;  :icon ("spoon" :set "faicon" :color "dorange")
;;                               ;;  :file +org-capture-recipies
;;                               ;;  :headline "Unsorted"
;;                               ;;  :template "%(org-chef-get-recipe-from-url)"
;;                               ;;  )
;;                               ("Information" :keys "i"
;;                                :icon ("info-circle" :set "faicon" :color "blue")
;;                                :desc ""
;;                                :i-type "read:info"
;;                                )
;;                               ("Idea" :keys "I"
;;                                :icon ("bubble_chart" :set "material" :color "silver")
;;                                :desc ""
;;                                :i-type "idea"
;;                                )))
;;                   ("Tasks" :keys "k"
;;                    :icon ("inbox" :set "octicon" :color "yellow")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Tasks"
;;                    :type entry
;;                    :template ("* TODO %? %^G%{extra}"
;;                               "%i %a")
;;                    :children (("General Task" :keys "k"
;;                                :icon ("inbox" :set "octicon" :color "yellow")
;;                                :extra ""
;;                                )
;;                               ("Task with deadline" :keys "d"
;;                                :icon ("timer" :set "material" :color "orange" :v-adjust -0.1)
;;                                :extra "\nDEADLINE: %^{Deadline:}t"
;;                                )
;;                               ("Scheduled Task" :keys "s"
;;                                :icon ("calendar" :set "octicon" :color "orange")
;;                                :extra "\nSCHEDULED: %^{Start time:}t"
;;                                )
;;                               ))
;;                   ("Project" :keys "p"
;;                    :icon ("repo" :set "octicon" :color "silver")
;;                    :prepend t
;;                    :type entry
;;                    :headline "Inbox"
;;                    :template ("* %{time-or-todo} %?"
;;                               "%i"
;;                               "%a")
;;                    :file ""
;;                    :custom (:time-or-todo "")
;;                    :children (("Project-local todo" :keys "t"
;;                                :icon ("checklist" :set "octicon" :color "green")
;;                                :time-or-todo "TODO"
;;                                :file +org-capture-project-todo-file)
;;                               ("Project-local note" :keys "n"
;;                                :icon ("sticky-note" :set "faicon" :color "yellow")
;;                                :time-or-todo "%U"
;;                                :file +org-capture-project-notes-file)
;;                               ("Project-local changelog" :keys "c"
;;                                :icon ("list" :set "faicon" :color "blue")
;;                                :time-or-todo "%U"
;;                                :heading "Unreleased"
;;                                :file +org-capture-project-changelog-file))
;;                    )
;;                   ("\tCentralised project templates"
;;                    :keys "o"
;;                    :type entry
;;                    :prepend t
;;                    :template ("* %{time-or-todo} %?"
;;                               "%i"
;;                               "%a")
;;                    :children (("Project todo"
;;                                :keys "t"
;;                                :prepend nil
;;                                :time-or-todo "TODO"
;;                                :heading "Tasks"
;;                                :file +org-capture-central-project-todo-file)
;;                               ("Project note"
;;                                :keys "n"
;;                                :time-or-todo "%U"
;;                                :heading "Notes"
;;                                :file +org-capture-central-project-notes-file)
;;                               ("Project changelog"
;;                                :keys "c"
;;                                :time-or-todo "%U"
;;                                :heading "Unreleased"
;;                                :file +org-capture-central-project-changelog-file))
;;                    ))))))

;; ;; make org capture dialog prettier
;; (defun org-capture-select-template-prettier (&optional keys)
;;   "Select a capture template, in a prettier way than default
;; Lisp programs can force the template by setting KEYS to a string."
;;   (let ((org-capture-templates
;;          (or (org-contextualize-keys
;;               (org-capture-upgrade-templates org-capture-templates)
;;               org-capture-templates-contexts)
;;              '(("t" "Task" entry (file+headline "" "Tasks")
;;                 "* TODO %?\n  %u\n  %a")))))
;;     (if keys
;;         (or (assoc keys org-capture-templates)
;;             (error "No capture template referred to by \"%s\" keys" keys))
;;       (org-mks org-capture-templates
;;                "Select a capture template\n━━━━━━━━━━━━━━━━━━━━━━━━━"
;;                "Template key: "
;;                `(("q" ,(concat (all-the-icons-octicon "stop" :face 'all-the-icons-red :v-adjust 0.01) "\tAbort")))))))
;; (advice-add 'org-capture-select-template :override #'org-capture-select-template-prettier)

;; (defun org-mks-pretty (table title &optional prompt specials)
;;   "Select a member of an alist with multiple keys. Prettified.

;; TABLE is the alist which should contain entries where the car is a string.
;; There should be two types of entries.

;; 1. prefix descriptions like (\"a\" \"Description\")
;;    This indicates that `a' is a prefix key for multi-letter selection, and
;;    that there are entries following with keys like \"ab\", \"ax\"…

;; 2. Select-able members must have more than two elements, with the first
;;    being the string of keys that lead to selecting it, and the second a
;;    short description string of the item.

;; The command will then make a temporary buffer listing all entries
;; that can be selected with a single key, and all the single key
;; prefixes.  When you press the key for a single-letter entry, it is selected.
;; When you press a prefix key, the commands (and maybe further prefixes)
;; under this key will be shown and offered for selection.

;; TITLE will be placed over the selection in the temporary buffer,
;; PROMPT will be used when prompting for a key.  SPECIALS is an
;; alist with (\"key\" \"description\") entries.  When one of these
;; is selected, only the bare key is returned."
;;   (save-window-excursion
;;     (let ((inhibit-quit t)
;;           (buffer (org-switch-to-buffer-other-window "*Org Select*"))
;;           (prompt (or prompt "Select: "))
;;           case-fold-search
;;           current)
;;       (unwind-protect
;;           (catch 'exit
;;             (while t
;;               (setq-local evil-normal-state-cursor (list nil))
;;               (erase-buffer)
;;               (insert title "\n\n")
;;               (let ((des-keys nil)
;;                     (allowed-keys '("\C-g"))
;;                     (tab-alternatives '("\s" "\t" "\r"))
;;                     (cursor-type nil))
;;                 ;; Populate allowed keys and descriptions keys
;;                 ;; available with CURRENT selector.
;;                 (let ((re (format "\\`%s\\(.\\)\\'"
;;                                   (if current (regexp-quote current) "")))
;;                       (prefix (if current (concat current " ") "")))
;;                   (dolist (entry table)
;;                     (pcase entry
;;                       ;; Description.
;;                       (`(,(and key (pred (string-match re))) ,desc)
;;                        (let ((k (match-string 1 key)))
;;                          (push k des-keys)
;;                          ;; Keys ending in tab, space or RET are equivalent.
;;                          (if (member k tab-alternatives)
;;                              (push "\t" allowed-keys)
;;                            (push k allowed-keys))
;;                          (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) (propertize "›" 'face 'font-lock-comment-face) "  " desc "…" "\n")))
;;                       ;; Usable entry.
;;                       (`(,(and key (pred (string-match re))) ,desc . ,_)
;;                        (let ((k (match-string 1 key)))
;;                          (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) "   " desc "\n")
;;                          (push k allowed-keys)))
;;                       (_ nil))))
;;                 ;; Insert special entries, if any.
;;                 (when specials
;;                   (insert "─────────────────────────\n")
;;                   (pcase-dolist (`(,key ,description) specials)
;;                     (insert (format "%s   %s\n" (propertize key 'face '(bold all-the-icons-red)) description))
;;                     (push key allowed-keys)))
;;                 ;; Display UI and let user select an entry or
;;                 ;; a sub-level prefix.
;;                 (goto-char (point-min))
;;                 (unless (pos-visible-in-window-p (point-max))
;;                   (org-fit-window-to-buffer))
;;                 (let ((pressed (org--mks-read-key allowed-keys prompt)))
;;                   (setq current (concat current pressed))
;;                   (cond
;;                    ((equal pressed "\C-g") (user-error "Abort"))
;;                    ;; Selection is a prefix: open a new menu.
;;                    ((member pressed des-keys))
;;                    ;; Selection matches an association: return it.
;;                    ((let ((entry (assoc current table)))
;;                       (and entry (throw 'exit entry))))
;;                    ;; Selection matches a special entry: return the
;;                    ;; selection prefix.
;;                    ((assoc current specials) (throw 'exit current))
;;                    (t (error "No entry available")))))))
;;         (when buffer (kill-buffer buffer))))))
;; (advice-add 'org-mks :override #'org-mks-pretty)

;; (setf (alist-get 'height +org-capture-frame-parameters) 15)
;; ;; (alist-get 'name +org-capture-frame-parameters) "❖ Capture") ;; ATM hardcoded in other places, so changing breaks stuff
;; (setq +org-capture-fn
;;       (lambda ()
;;         (interactive)
;;         (set-window-parameter nil 'mode-line-format 'none)
;;         (org-capture)))

;; (after! org-agenda
;;   (org-super-agenda-mode))

;; (setq org-agenda-skip-scheduled-if-done t
;;       org-agenda-skip-deadline-if-done t
;;       org-agenda-include-deadlines t
;;       org-agenda-block-separator nil
;;       org-agenda-tags-column 100 ;; from testing this seems to be a good value
;;       org-agenda-compact-blocks t)

;; (setq org-agenda-custom-commands
;;       '(("n" "Overview"
;;          ((agenda "" ((org-agenda-span 'day)
;;                       (org-super-agenda-groups
;;                        '((:name "Today"
;;                           :time-grid t
;;                           :date today
;;                           :todo "TODAY"
;;                           :scheduled today
;;                           :order 1)))))
;;           (alltodo "" ((org-agenda-overriding-header "")
;;                        (org-super-agenda-groups
;;                         '((:name "Next to do"
;;                            :todo "NEXT"
;;                            :order 1)
;;                           (:name "Important"
;;                            :tag "Important"
;;                            :priority "A"
;;                            :order 6)
;;                           (:name "Due Today"
;;                            :deadline today
;;                            :order 2)
;;                           (:name "Due Soon"
;;                            :deadline future
;;                            :order 8)
;;                           (:name "Overdue"
;;                            :deadline past
;;                            :face error
;;                            :order 7)
;;                           ;; (:name "Issues"
;;                           ;;        :tag "Issue"
;;                           ;;        :order 12)
;;                           (:name "Emacs"
;;                            :tag "emacs"
;;                            :order 13)
;;                           (:name "Projects"
;;                            :tag "project"
;;                            :order 14)
;;                           (:name "Research"
;;                            :tag "research"
;;                            :order 15)
;;                           (:name "To read"
;;                            :tag "read"
;;                            :order 30)
;;                           (:name "Waiting"
;;                            :todo "WAITING"
;;                            :order 20)
;;                           (:name "University"
;;                            :tag "uni"
;;                            :order 32)
;;                           (:name "School"
;;                            :tag "school"
;;                            :order 32)
;;                           (:name "Abitur"
;;                            :tag "abi"
;;                            :order 30)
;;                           (:name "Trivial"
;;                            :priority<= "E"
;;                            :tag ("trivial" "unimportant" "rec")
;;                            :todo ("SOMEDAY" )
;;                            :order 90)
;;                           (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

;; org tree slide
(after! org
  (setq org-tree-slide-breadcrumbs nil
        org-tree-slide-header nil
        org-tree-slide-slide-in-effect nil
        org-tree-slide-heading-emphasis nil
        org-tree-slide-cursor-init t
        org-tree-slide-modeline-display nil
        org-tree-slide-skip-done nil
        org-tree-slide-skip-comments t
        org-tree-slide-fold-subtrees-skipped t
        org-tree-slide-skip-outline-level 8
        org-tree-slide-never-touch-face t))

;; org mode
(setq org-directory "~/org"
      org-default-notes-file (concat org-directory "/notes.org"))

(with-eval-after-load 'ox
  (require 'ox-hugo))

;; ;; (require 'org)
(after! org
  (setq org-ellipsis "  ")
  (setq org-cycle-separator-lines -1)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "|" "DONE(d)" "CANCELLED(c)")
          (sequence "STUDY(s)" "|" "STUDIED(S)"))))

;;   ;; make background of fragments transparent
;;   ;; (let ((dvipng--plist (alist-get 'dvipng org-preview-latex-process-alist)))
;;   ;;   (plist-put dvipng--plist :use-xcolor t)
;;   ;;   (plist-put dvipng--plist :image-converter '("dvipng -D %D -bg 'transparent' -T tight -o %O %f")))
;;   (add-hook! 'doom-load-theme-hook
;;     (defun +org-refresh-latex-background ()
;;       (plist-put! org-format-latex-options
;;                   :background
;;                   (face-attribute (or (cadr (assq 'default face-remapping-alist))
;;                                       'default)
;;                                   :background nil t))))
;;   (setq org-fontify-done-headline nil
;;         org-highlight-latex-and-related '(native script entities)
;;         org-fontify-whole-heading-line nil
;;         org-enforce-todo-dependencies t
;;         org-enforce-todo-checkbox-dependencies t
;;         org-track-ordered-property-with-tag t
;;         org-highest-priority ?a
;;         org-lowest-priority ?c
;;         org-default-priority ?a
;;         ;;   org-capture-templates
;;         ;; '(("b" "basic task" entry
;;         ;;   (file+headline "todo.org" "basic tasks that need to be reviewed")
;;         ;;   "* TODO %?")
;;         ;;   ("n" "notes" entry
;;         ;;    (file+headline "notes.org" "Quick note taking")
;;         ;;    "** %?")
;;         ;;   ("c" "capture some concise actionable item and exit immediately" entry
;;         ;;   (file+headline "todo.org" "task list without a defined date")
;;         ;;   "* TODO [#b] %^{title}\n :properties:\n :captured: %u\n :end:\n\n %i %l" :immediate-finish t)
;;         ;;   ("t" "task of importance with a tag, deadline, and further editable space" entry
;;         ;;   (file+headline "todo.org" "task list with a date")
;;         ;;   "* %^{scope of task||TODO [#a]|STUDY [#a]|MEET meet with} %^{title} %^g\n deadline: %^t\n :properties:\n :context: %a\n :captured: %u\n :end:\n\n %i %?")
;;         ;;   ("i" "idea")
;;         ;;   ("ia" "activity or event" entry
;;         ;;   (file+headline "ideas.org" "activities or events")
;;         ;;   "* act %^{act about what}%? :private:\n :properties:\n :captured: %u\n :end:\n\n %i")
;;         ;;   ("ie" "essay or publication" entry
;;         ;;   (file+headline "ideas.org" "essays or publications")
;;         ;;   "* study %^{expound on which thesis}%? :private:\n :properties:\n :captured: %u\n :end:\n\n %i")
;;         ;;   ("iv" "video blog or screen cast" entry
;;         ;;   (file+headline "ideas.org" "screen casts or vlogs")
;;         ;;   "* record %^{record on what topic}%? :private:\n :properties:\n :captured: %u\n :end:\n\n %i"))
;;         ))

(setq hl-todo-keyword-faces
      '(("TODO"      . warning)
        ("ACT"       . warning)
        ("BUY"       . warning)
        ("MEET"      . warning)
        ("STUDY"     . warning)
        ("REVIEW"    . warning)
        ("FIXME"     . warning)
        ("DONE"      . success)
        ("ACTED"     . success)
        ("BOUGHT"    . success)
        ("MET"       . success)
        ("STUDIED"   . success)
        ("CANCELLED"  . error)
        ("POSTPONED" . error)
        ))

;; ;; stolen from reddit
;; (setq-hook! org-mode
;;   org-log-done t
;;   org-image-actual-width '(700)
;;   org-clock-into-drawer t
;;   org-clock-persist t
;;   org-columns-default-format "%60ITEM(Task) %20TODO %10Effort(Effort){:} %10CLOCKSUM"
;;   org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
;;                                 ("STYLE_ALL" . "habit")))
;;   ;; org-plantuml-jar-path (expand-file-name "~/Downloads/plantuml.jar")
;;   ;; org-export-babel-evaluate nil
;;   org-confirm-babel-evaluate nil
;;   ;; org-todo-keywords '((sequence "TODO" "WAITING" "|" "DONE"))
;;   org-archive-location "~/org/archive/todo.org.gpg::"
;;   org-duration-format '((special . h:mm))
;;   org-time-clocksum-format (quote (:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))
;;   bidi-paragraph-direction t
;;   org-icalendar-timezone "Europe/Berlin"
;;   org-hide-emphasis-markers t
;;   org-fontify-done-headline t
;;   org-fontify-whole-heading-line t
;;   org-fontify-quote-and-verse-blocks t
;;   )
;; (setq org-agenda-block-separator (string-to-char " ")
;;     org-deadline-warning-days 7
;;     org-agenda-breadcrumbs-separator " ❱ "
;;     org-agenda-format-date 'my-org-agenda-format-date-aligned)

;; automatically toggle latex previews
;; (add-hook 'org-mode-hook 'org-fragtog-mode)

;; changing the bullets in org-mode
;; (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
;; (setq org-superstar-headline-bullets-list '( "⁖" "⁖" "⁖" "⁖" "⁖" ))
;; (setq org-superstar-prettify-item-bullets nil)
;; (setq org-superstar-headline-bullets-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷"))

(setq org-refile-targets '((nil :maxlevel . 9)
                           (org-agenda-files :maxlevel . 9)))
(setq org-outline-path-complete-in-steps nil)         ; Refile in a single go
(setq org-refile-use-outline-path t)                  ; Show full paths for refiling
;; (setq bookmark-default-file '("/Users/supremesnickers/.config/doom/bookmarks"))

(setq deft-directory "~/Roam"
      deft-recursive t
      deft-use-filename-as-title t)

(setq org-fontify-quote-and-verse-blocks t
      org-list-allow-alphabetical t               ; have a. A. a) A) list bullets
      org-catch-invisible-edits 'smart)           ; try not to accidently do weird stuff in invisible regions

;; (add-hook! 'org-mode-hook #'+org-pretty-mode #'mixed-pitch-mode)
(setq projectile-project-search-path '("~/cs" "~/dotfiles" "~/clones"))
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

(provide 'org-config)
;; Org mode:2 ends here

;; [[file:config.org::*Org mode][Org mode:3]]
;; change latex export to use latexmk
(setq org-latex-pdf-process '("latexmk -f -pdf -%latex -shell-escape -interaction=nonstopmode -output-directory=%o %f"))

;; ;; add language support in latex export
;; (add-to-list 'org-latex-packages-alist
;;              '("AUTO" "babel" t ("pdflatex")))
;; (add-to-list 'org-latex-packages-alist
;;              '("AUTO" "polyglossia" t ("xelatex" "lualatex")))
;; Org mode:3 ends here

;; [[file:config.org::*mu4e][mu4e:1]]
(when IS-MAC
  (setq mu4e-html2text-command
        "textutil -stdin -format html -convert txt -stdout")
  )
;; mu4e:1 ends here

;; [[file:config.org::*dired][dired:1]]
(after! dired
  (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map)
  (bind-key "<backtab>" #'dired-subtree-cycle dired-mode-map)
  (map! :n "-" #'dired-jump)
  (setq dired-subtree-use-backgrounds nil)
  ;; (add-hook 'dired-mode-hook #'dired-hide-details-mode))
  )

(when IS-MAC
  (progn
    (setq dired-use-ls-dired t
          insert-directory-program "/usr/local/bin/gls"
          dired-listing-switches "-aBhl --group-directories-first")))
;; dired:1 ends here

(setq org-roam-directory "~/Roam")

(after! org-roam
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
        (directory-file-name
          (file-name-directory
          (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error ""))))

(setq org-roam-capture-templates
      '(("m" "main" plain "%?"
         :if-new
         (file+head "main/%<%Y%m%d%H%M%S>-${slug}.org"
                    "#+include: \"../head.org\"\n#+title: ${title}\n#+filetags: \n")
         :immediate-finish t
         :unnarrowed t)
        ("e" "exercise" plain "%?"
         :if-new
         (file+head "exercises/${title}.org" "#+title: ${title}\n#+filetags: :exercise:\n")
         :immediate-finish t
         :unnarrowed t)))

(defvar uni-current-semester-path nil
  "Current semester root path.")
(defvar uni-current-course-path nil
  "Current course that I'm acting in.")

(setq uni-root-path "~/org/uni")

(setq uni-current-course-symlink "~/org/uni/current-course")

(setq uni-current-semester-path (concat uni-root-path "/sem-2"))

(setq uni-current-course-path (file-truename uni-current-course-symlink))

(defun uni--get-master-file (path)
  (expand-file-name "master.org" path))

(defun uni--number-to-filename (num)
  (format "lec_%02d.org" num)
  )

(defun uni--directory-to-title (dir)
  (s-titleize (s-replace "-" " " dir)))

(defun uni-get-all-courses (&optional path)
  "Gets all courses of a semester (by default current semester)."
  (unless path
    (setq path uni-current-semester-path))
  (-filter #'file-directory-p
           (directory-files path 'full (rx bos (not "\.")) 'nosort)))

(defun uni-get-all-lectures (path)
  (directory-files path 'full
                   (rx "lec_" (zero-or-more (any word)) "\.org" eos) 'sort))

(defun uni-get-course-info (path)
  "Reads the toplevel info.yml file and returns a parsed lisp representation."
  (require 'yaml)
  (with-current-buffer
      (find-file-noselect (expand-file-name "info.yml" path))
    (yaml-parse-string (buffer-substring-no-properties (point-min) (point-max))
                       :object-type 'alist
                       :sequence-type 'array
                       :null-object :empty)))

(defun uni-set-course-symlink (path)
  (progn
    (delete-file uni-current-course-symlink)
    (make-symbolic-link path uni-current-course-symlink)
    (setq uni-current-course-path (file-truename uni-current-course-symlink))))

(defun uni-choose-course-symlink (&optional path)
  "Set a course inside the current semester as the current course."
  (interactive "P")
  ;; path is a short string to make selecting easier
  (unless path
    (setq path (ivy-read "Select course: " (-map #'file-name-nondirectory (uni-get-all-courses)))))
  ;; fpath is the full path
  (let ((fpath (expand-file-name path uni-current-semester-path)))
    (if (-contains? (uni-get-all-courses) fpath)
        (uni-set-course-symlink fpath)

      (when (y-or-n-p
             (format "Create new course %s in %s? "
                     (file-name-nondirectory fpath)
                     (file-name-nondirectory uni-current-semester-path)))
        (make-directory fpath)
        (uni-init-course fpath)
        (uni-set-course-symlink fpath)))))

(map!
 :leader
 :prefix ("k" . "uni")
 :desc "Set different/new course"
 :n "c" #'uni-choose-course-symlink)

(defun uni-set-current-semester (&optional path)
  "Set a folder in the uni root directory as the current semester root."
  (interactive "P")
  (unless path
    (setq path (ivy-read "Select semester: "
                         (-filter
                          (lambda (file) (and (file-directory-p file) (not (file-symlink-p file))))
                          (directory-files uni-root-path 'full (rx (not "\.") eos))))))
  (setq uni-current-semester-path path))

(defun uni-update-master-with-lectures (path)
  "Updates the master.org file of the given course to include all lectures."
  (let ((lecs (uni-get-all-lectures path)))
    (with-current-buffer
        (find-file-noselect (uni--get-master-file path))
      (goto-char (point-min))
      (re-search-forward "^\# begin lectures")
      (forward-line)
      (let ((beg (point)))
        (re-search-forward "^\# end lectures")
        (forward-line -1)
        (end-of-line)
        (delete-region beg (point)))
      (mapc (lambda (lec) (insert (format "#+INCLUDE: \"%s\"\n" (file-name-nondirectory lec)))) lecs)
      (delete-char 1)
      (save-buffer))))

(defun uni-update-all-masters ()
  "Updates all available master files with their lectures."
  (interactive)
  (let* ((semesters
          (-filter
           (lambda (dir) (and (file-directory-p dir) (not (file-symlink-p dir))))
           (directory-files uni-root-path 'full (rx (not "\.") eos))))
         (courses (-map (lambda (sem) (uni-get-all-courses sem)) semesters)))
    (-map (lambda (course) (uni-update-master-with-lectures course)) (-flatten courses))))

(defun uni-new-lecture (&optional path)
  "Creates a new lecture org file in a course directory (by default the current),
whose number is bigger than the last lecture and visits it."
  (interactive)
  (unless path
    (setq path uni-current-course-path))
  (let ((next-num
         (+ 1 (length
               (directory-files path nil (rx "lec_" (zero-or-more (any num)) "\.org") t)))))
    (with-current-buffer
        (find-file-noselect
         (expand-file-name (uni--number-to-filename next-num) path))
      (insert "* Thema Vorlesung\n")
      (switch-to-buffer (current-buffer)))))

(map!
 :leader
 :prefix ("k" . "uni")
 :desc "New lecture in current"
 :n "n" #'uni-new-lecture)

;; [[file:config.org::*Functions and bindings][Functions and bindings:8]]
(defun uni-init-course (path)
  "Creates the course directory structure."
  (interactive)
  (progn
    (with-temp-file (expand-file-name "info.yml" path)
      (insert
       (format "title: %s\n" (uni--directory-to-title (file-name-nondirectory path)))
       (concat "url:\n" "short:\n")))
    (let ((info (uni-get-course-info path)))
      (with-temp-file (uni--get-master-file path)
        (insert
         (format "#+TITLE: %s\n" (cdr (assoc 'title info)))
         (format "#+INCLUDE: '%s/preamble.org'\n" uni-current-semester-path)
         (concat "# begin lectures\n"
                 "# end lectures\n"))
        (write-file "master.org"))
      (uni-new-lecture path))))
;; Functions and bindings:8 ends here

(defun uni-open-course-directory (&optional path)
  "Opens the course directory (default current course)."
  (interactive)
  (unless path
    (let ((path uni-current-course-path))
      (dired path))))

(map!
 :leader
 :prefix ("k" . "uni")
 :desc "Open course directory"
 :n "d" #'uni-open-course-directory)

(defun uni-find-file-in-directory (&optional path)
  "Search for a file in `uni-current-course-path'."
  (interactive)
  (unless path
    (let ((path uni-current-course-path))
      (doom-project-find-file path)))) ;; TODO show current course in prompt

(map!
 :leader
 :prefix ("k" . "uni")
 :desc "Find file in current course"
 :n "f" #'uni-find-file-in-directory)

(defun my-yas-try-expanding-auto-snippets ()
  (when (and (boundp 'yas-minor-mode) yas-minor-mode)
    (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
      (yas-expand))))
(add-hook 'post-command-hook #'my-yas-try-expanding-auto-snippets)

(use-package aas
  :hook (LaTeX-mode . ass-activate-for-major-mode)
  :hook (org-mode . ass-activate-for-major-mode))

(use-package! laas
  :hook (LaTeX-mode . laas-mode)
  :hook (org-mode . laas-mode)
  :config ; do whatever here
  (aas-set-snippets 'laas-mode
                    ;; set condition!
                    :cond #'texmathp ; expand only while in math
                    "supp" "\\supp"
                    "On" "O(n)"
                    "O1" "O(1)"
                    "Olog" "O(\\log n)"
                    "Olon" "O(n \\log n)"
                    ;; bind to functions!
                    "\\\\" (lambda () (interactive)
                             (yas-expand-snippet "\\frac{$1}{$2}$0"))
                    "Span" (lambda () (interactive)
                             (yas-expand-snippet "\\Span($1)$0"))))

(after! laas-mode
  (aas--format-doc-to-org 'laas-subscript-snippets)
  (aas--format-snippet-array laas-subscript-snippets)
  (aas--format-doc-to-org 'laas-frac-snippet)
  (aas--format-snippet-array laas-frac-snippet)
  (aas--format-doc-to-org 'laas-accent-snippets)
  (aas--format-snippet-array laas-accent-snippets))

;; [[file:config.org::*rest][rest:1]]
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; rest:1 ends here

;; [[file:config.org::*rest][rest:2]]
;; pretty code
;; (remove-hook! 'text-mode-hook #'display-line-numbers-mode)
;; (add-hook! 'text-mode-hook :append (setq-local display-line-numbers nil))
;; (add-hook 'TeX-mode-hook (lambda () (prettify-symbols-mode)))
(setq global-prettify-symbols-mode nil)
(remove-hook! 'c-mode 'prettify-symbols-mode)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (require 'elisp-autofmt)
            (elisp-autofmt-save-hook-for-this-buffer)))

;; ;; latex
;; (latex-preview-pane-enable)
;; (require 'tex)
;; (TeX-global-PDF-mode t)

;; ;; PDF
;; (pdf-tools-install)
;; (require 'pdf-view-mode)
;; (setq-default pdf-view-display-size 'fit-page)
;; (bind-keys :map pdf-view-mode-map
;;            ("\\" . hydra-pdftools/body)
;;            ("<s-spc>" .  pdf-view-scroll-down-or-next-page)
;;            ("g"  . pdf-view-first-page)
;;            ("G"  . pdf-view-last-page)
;;            ("l"  . image-forward-hscroll)
;;            ("h"  . image-backward-hscroll)
;;            ("j"  . pdf-view-next-page)
;;            ("k"  . pdf-view-previous-page)
;;            ("e"  . pdf-view-goto-page)
;;            ("u"  . pdf-view-revert-buffer)
;;            ("al" . pdf-annot-list-annotations)
;;            ("ad" . pdf-annot-delete)
;;            ("aa" . pdf-annot-attachment-dired)
;;            ("am" . pdf-annot-add-markup-annotation)
;;            ("at" . pdf-annot-add-text-annotation)
;;            ("y"  . pdf-view-kill-ring-save)
;;            ("i"  . pdf-misc-display-metadata)
;;            ("s"  . pdf-occur)
;;            ("b"  . pdf-view-set-slice-from-bounding-box)
;;            ("r"  . pdf-view-reset-slice))

;; yasnippet
(add-to-list 'load-path
             "~/.emacs.d/plugins/yasnippet")
(yas-global-mode 1)

(global-set-key (kbd "C-s") 'swiper-isearch)

(ivy-rich-mode 1)

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))
(setq +ivy-buffer-preview t)

(map! :map evil-window-map
      "SPC" #'rotate-layout
      ;; Navigation
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; Swapping windows
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)

;; (global-pretty-mode t)
(rainbow-mode)

(defun rainbow-turn-off-words ()
  "Turn off word colours in rainbow-mode."
  (interactive)
  (font-lock-remove-keywords
   nil
   `(,@rainbow-x-colors-font-lock-keywords
     ,@rainbow-latex-rgb-colors-font-lock-keywords
     ,@rainbow-r-colors-font-lock-keywords
     ,@rainbow-html-colors-font-lock-keywords
     ,@rainbow-html-rgb-colors-font-lock-keywords)))

;; elfeed
(after! elfeed
  (setq elfeed-search-filter "@1-month-ago +unread "))

  ;; (defface elfeed-show-title-face '((t (:weight ultrabold :slant italic :height 1.5)))
  ;;   "title face in elfeed show buffer"
  ;;   :group 'elfeed)
  ;; (defface elfeed-show-author-face `((t (:weight light)))
  ;;   "title face in elfeed show buffer"
  ;;   :group 'elfeed)
  ;; (set-face-attribute 'elfeed-search-title-face nil
  ;;                     :foreground 'nil
  ;;                     :weight 'light)

;;   (defadvice! +rss-elfeed-wrap-h-nicer ()
;;     "Enhances an elfeed entry's readability by wrapping it to a width of
;; `fill-column' and centering it with `visual-fill-column-mode'."
;;     :override #'+rss-elfeed-wrap-h
;;     (setq-local truncate-lines nil
;;                 shr-width 120
;;                 visual-fill-column-center-text t
;;                 default-text-properties '(line-height 1.1))
;;     (let ((inhibit-read-only t)
;;           (inhibit-modification-hooks t))
;;       (visual-fill-column-mode)
;;       ;; (setq-local shr-current-font '(:family "Merriweather" :height 1.2))
;;       (set-buffer-modified-p nil))))

(map! :leader
      :prefix ("o" . "open")
      :desc "Elfeed" "E" #'=rss)

(add-hook! 'elfeed-search-mode-hook 'elfeed-update)

;; lorem ipsum
;; (lorem-ipsum-use-default-bindings)
(map! (:leader
       (:desc "insert lorem" :prefix "i l"
        :desc "insert lorem list"        :nv     "l" #'lorem-ipsum-insert-list
        :desc "insert lorem paragraph"   :nv     "p" #'lorem-ipsum-insert-paragraphs
        :desc "insert lorem sentence"    :nv     "o" #'lorem-ipsum-insert-sentences)))

;; open main index file
(map! :leader
      :prefix "o"
      (:desc "Main index" "o" #'(lambda () (interactive) (find-file "~/org/index.org")))
      :desc "Open calendar" "c" #'org-goto-calendar)
;; start drill session
(map! :map org-mode-map
      :leader
      :desc "org-drill" "m D" #'org-drill)

;; which key
;; replace all evil-* entries
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂ \\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃ \\1"))
   ))
(setq which-key-idle-delay 0.5) ;; I need the help, I really do
;; rest:2 ends here
