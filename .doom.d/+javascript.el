;;; ~/.doom.d/+javascript.el -*- lexical-binding: t; -*-

(require 'prettier-js)

;; (defun ij/setup-tide-mode()
;;   "Setup function for tide"
;;   (interactive)
;;   (tide-setup)
;;   (flycheck-mode +1)
;;   (setq tide-completion-detailed t
;;         tide-always-show-documentation t)
;;   (tide-hl-identifier-mode +1)
;;   (company-mode +1))

(add-hook! (rjsx-mode js2-mode)
     #'(prettier-js-mode))

;; (add-hook! (rjsx-mode)
;;            #'(ij/setup-tide-mode))

;; (setenv "NODE_PATH"
;;     (concat
;;       (getenv "HOME") "~/Desktop/03-resources/org-roam/node_modules"  ":"
;;       (getenv "NODE_PATH")
;;     )
;;   )
