;;; ~/.doom.d/+org.el -*- lexical-binding: t; -*-

(setq
   org_notes "~/Desktop/03-resources/org-roam"
   zot_bib "~/Desktop/03-resources/masterLib.bib"
   org-directory "~/Desktop/03-resources/org-roam"
   deft-directory "~/Desktop/03-resources/org-roam"
   org-roam-directory "~/Desktop/03-resources/org-roam"
   org-default-notes-file "~/Desktop/03-resources/org-roam/inbox.org"
   +biblio-pdf-library-dir "~/Desktop/03-resources/org-roam/pdfs/"
   +biblio-default-bibliography-files '("~/Desktop/03-resources/masterLib.bib")
   +biblio-notes-path "~/Desktop/03-resources/org-roam/"
   )

;; I use C-c c to start capture mode
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-pomodoro-play-sounds t
      org-pomodoro-short-break-sound-p t
      org-pomodoro-long-break-sound-p t
      org-pomodoro-short-break-sound (expand-file-name "/System/Library/Sounds/Blow.aiff")
      org-pomodoro-long-break-sound (expand-file-name "/System/Library/Sounds/Blow.aiff")
      org-pomodoro-finished-sound (expand-file-name "/System/Library/Sounds/Blow.aiff"))

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protoco
(after! org
  (setq org-capture-templates
        (quote (("t" "todo" entry (file "~/Desktop/03-resources/org-roam/todo.org")
                 "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
                ("r" "respond" entry (file "~/Desktop/03-resources/org-roam/todo.org")
                 "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
                ("n" "note" entry (file "~/Desktop/03-resources/org-roam/todo.org/notes")
                 "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
                ("w" "org-protocol" entry (file "~/Desktop/03-resources/org-roam/todo.org")
                 "* TODO Review %c\n%U\n" :immediate-finish t)
                ("m" "Meeting" entry (file "~/Desktop/03-resources/org-roam/todo.org")
                 "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
                ("p" "Phone call" entry (file "~/Desktop/03-resources/org-roam/todo.org")
                 "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
                ("h" "Habit" entry (file "~/Desktop/03-resources/org-roam/todo.org")
                 "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")))))

;; Remove empty LOGBOOK drawers on clock out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

;; Org Roam
(after! org-roam
  (setq org-roam-graph-viewer "/usr/bin/open")
  (setq org-roam-ref-capture-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "websites/${slug}"
           :head "#+title: ${title}
#+roam_key: ${ref}
- source :: ${ref}"
           :unnarrowed t)))
  (setq org-roam-capture-templates
        '(("d" "default" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "${slug}"
           :head "#+title: ${title}\n"
           :unnarrowed t))))


;; (let* ((variable-tuple
;;         (cond ((x-list-fonts "Open Sans")       '(:font "Open Sans"))
;;               ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
;;               ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
;;               ((x-list-fonts "Verdana")         '(:font "Verdana"))
;;               ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
;;               (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro.")))))
;;   (custom-theme-set-faces
;;    'user
;;    `(org-level-8 ((t (,@variable-tuple))))
;;    `(org-level-7 ((t (,@variable-tuple))))
;;    `(org-level-6 ((t (,@variable-tuple))))
;;    `(org-level-5 ((t (,@variable-tuple))))
;;    `(org-level-4 ((t (,@variable-tuple :height 1.1))))
;;    `(org-level-3 ((t (,@variable-tuple :height 1.2))))
;;    `(org-level-2 ((t (,@variable-tuple :height 1.3))))
;;    `(org-level-1 ((t (,@variable-tuple :height 1.4))))
;;    `(org-document-title ((t (,@variable-tuple :height 1.5 :underline nil))))))

(use-package org-roam-bibtex
  :after (org-roam)
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config
  (setq orb-preformat-keywords
   '("=key=" "title" "url" "file" "author-or-editor" "keywords"))
  (setq orb-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           ""
           :file-name "${slug}"
           :head "#+title: ${=key=}: ${title}\n#+roam_key: ${ref}

- tags ::
- keywords :: ${keywords}

\n* ${title}\n  :PROPERTIES:\n  :Custom_ID: ${=key=}\n  :URL: ${url}\n  :AUTHOR: ${author-or-editor}\n  :NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n  :NOTER_PAGE: \n  :END:\n\n"

           :unnarrowed t))))

(use-package! org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; The WM can handle splits
   org-noter-notes-window-location 'horizontal-split
   ;; Please stop opening frames
   org-noter-always-create-frame nil
   ;; I want to see the whole file
   org-noter-hide-other nil
   ;; Everything is relative to the main notes file
   org-noter-notes-search-path (list "~/Desktop/03-resources/org-roam")
   )
  )

(use-package org-noter-pdftools
  :after org-noter
  :config
  (with-eval-after-load 'pdf-annot
    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))


;; Helm Bibtex
(setq
 bibtex-completion-notes-path "~/Desktop/03-resources/org-roam"
 bibtex-completion-bibliography "~/Desktop/03-resources/masterLib.bib"
 bibtex-completion-pdf-field "file"
 bibtex-completion-notes-template-multiple-files
 (concat
  "#+title: ${title}\n"
  "#+roam_key: cite:${=key=}\n"
  "* TODO Notes\n"
  ":PROPERTIES:\n"
  ":Custom_ID: ${=key=}\n"
  ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
  ":AUTHOR: ${author-abbrev}\n"
  ":JOURNAL: ${journaltitle}\n"
  ":DATE: ${date}\n"
  ":YEAR: ${year}\n"
  ":DOI: ${doi}\n"
  ":URL: ${url}\n"
  ":END:\n\n"
  )
 )

(use-package! org-ref
    :config
    (setq
         org-ref-completion-library 'org-ref-ivy-cite
         org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
         org-ref-default-bibliography (list "~/Desktop/03-resources/masterLib.bib")
         org-ref-bibliography-notes "~/Desktop/03-resources/org-roam"
         org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
         org-ref-notes-directory "~/Desktop/03-resources/org-roam"
         org-ref-notes-function 'orb-edit-notes
    ))

;; Deft
;; (use-package deft
;;   :after org
;;   :bind
;;   ("C-c n d" . deft)
;;   :custom
;;   (deft-recursive t)
;;   (deft-use-filter-string-for-filename t)
;;   (deft-default-extension "org")
;;   (deft-auto-save-interval -1.0)
;;   (deft-directory org_notes))

(use-package org-journal
  :bind
  ("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-dir "~/Desktop/03-resources/org-roam")
  (org-journal-date-prefix "#+title: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-format "%A, %d %B %Y"))
(setq org-journal-enable-agenda-integration t)

(after! org-journal
  (set-company-backend! 'org-journal-mode 'company-org-roam))

(after! org
  (map! :map org-mode-map
        :n "M-j" #'org-metadown
        :n "M-k" #'orge-metaup))

(use-package org-roam-server
    :ensure t)

(add-hook 'org-roam-server-mode (lambda () (browse-url-chrome "http://localhost:8080")))


;; Refile a heading to another buffer
;; Allows you to refile into different files - specifically to
;; create new 'parent' headings
(setq org-refile-use-outline-path 'file)
;; makes org-refile outline working with helm/ivy
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(defun +org/opened-buffer-files ()
  "Return the list of files currently opened in emacs"
  (delq nil
        (mapcar (lambda (x)
                  (if (and (buffer-file-name x)
                           (string-match "\\.org$"
                                         (buffer-file-name x)))
                      (buffer-file-name x)))
                (buffer-list))))

(setq org-refile-targets '((+org/opened-buffer-files :maxlevel . 9)))

