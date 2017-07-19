(defconst kd/emacs-directory (concat (getenv "HOME") "/.emacs.d/"))
(defun kd/emacs-subdirectory (d) (expand-file-name d kd/emacs-directory))

(define-prefix-command 'kd/toggle-map)
(define-key ctl-x-map "t" 'kd/toggle-map)

;;; customization file
(setq custom-file (kd/emacs-subdirectory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;;; package initialize
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
;; You can turn this on to see when exactly a package get's configured
;; (setq use-package-verbose t)

;;; general
(use-package better-defaults
  :ensure t)

(setq scroll-conservatively 1)
(setq vc-follow-symlinks t)

;;; tab
(setq-default default-tab-width 4)

;;; display
(setq initial-scratch-message "")
(setq visible-bell t)
(global-visual-line-mode t)

(when (window-system)
  ;; (load-theme 'default-black t)
  (tool-bar-mode 0)
  (when (fboundp 'horizontal-scroll-bar-mode)
    (horizontal-scroll-bar-mode -1))
  (scroll-bar-mode -1)
  (column-number-mode 1)
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (set-face-attribute 'default nil :font "-apple-luculent 16-regular-normal-normal-*-16-*-*-*-m-0-iso10646-1"))

(use-package cyberpunk-theme
  :ensure t)

(when (eq system-type 'darwin)
    (defun kd/osx-lock-screen ()
      (interactive)
      (start-process "lock-screen" nil "/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession" "-suspend"))
    (define-key kd/toggle-map "l" #'kd/osx-lock-screen)
    (setq mac-option-modifier 'meta))

; show whitespace
(use-package whitespace
  :commands whitespace-mode
  :init
  (define-key kd/toggle-map "w" 'whitespace-mode)
  (setq whitespace-line-column nil
        whitespace-display-mappings '((space-mark 32 [183] [46])
                                      (newline-mark 10 [9166 10])
                                      (tab-mark 9 [9654 9] [92 9])))
  :config
  (set-face-attribute 'whitespace-space       nil :foreground "#666666" :background nil)
  (set-face-attribute 'whitespace-newline     nil :foreground "#666666" :background nil)
  (set-face-attribute 'whitespace-indentation nil :foreground "#666666" :background nil)
  :diminish whitespace-mode)

; auto wrap
(use-package fill
  :commands auto-fill-mode
  :init
  (define-key kd/toggle-map "f" 'auto-fill-mode)
  :diminish auto-fill-mode)

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode 1))

(use-package wgrep
  :ensure t)

(use-package winner
  :commands winner-mode
  :init
  (add-hook 'after-init-hook #'winner-mode))

(use-package narrow-indirect
  :ensure t)

;;; dired
(use-package dired
  :init
  (setq dired-listing-switches "-lahF")
  (setq dired-isearch-filenames t)
  (setq dired-ls-F-marks-symlinks t)
  (add-hook 'dired-mode-hook #'dired-hide-details-mode))

(use-package dired-x
  :commands dired-omit-mode
  :init
  (add-hook 'dired-mode-hook #'dired-omit-mode))

(use-package zoom-window
  :ensure t
  :bind ("C-x C-z" . zoom-window-zoom))

;;; ido
(use-package ido
  :ensure t
  :commands ido-mode
  :init
  (add-hook 'after-init-hook (lambda ()
                               (ido-mode 1)
                               (ido-everywhere 1)
                               (flx-ido-mode 1)
                               (ido-vertical-mode 1)
                               (ido-at-point-mode 1)))
  :config
  ;; disable ido faces to see flx highlights.
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil))

(use-package flx-ido
  :ensure t
  :commands flx-ido-mode)

(use-package ido-vertical-mode
  :ensure t
  :commands ido-vertical-mode
  :config
  (setq ido-vertical-define-keys 'C-n-and-C-p-only))

(use-package ido-at-point
  :ensure t
  :commands ido-at-point-mode)

(use-package find-file-in-project
  :ensure t
  :bind ("C-c o" . find-file-in-project))

(use-package avy
  :ensure t
  :bind
  (("C-c SPC" . avy-goto-char)
   ("C-c l" . avy-goto-line)))

(use-package rg
  :ensure t
  :bind (("C-c a" . rg-dwim)
         ("C-c C-a" . rg-project)))

(use-package magit
  :ensure t
  :bind (("C-c g s" . magit-status)
         ("C-c g l" . magit-log-current)))
  :config
  (setq magit-git-executable "/usr/local/bin/git")

(use-package mo-git-blame
  :ensure t
  :bind ("C-c g b" . mo-git-blame-current))

(use-package git-gutter
  :ensure t
  :commands global-git-gutter-mode
  :diminish git-gutter-mode
  :init
  (add-hook 'after-init-hook #'global-git-gutter-mode))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package smartscan
  :ensure t
  :bind
  (("M-n" . smartscan-symbol-go-forward)
   ("M-p" . smartscan-symbol-go-backward)))

(use-package hydra
  :ensure t
  :config
  (defhydra hydra-zoom (global-map "<f2>")
    "zoom"
    ("g" text-scale-increase "in")
    ("l" text-scale-decrease "out"))
  (defhydra hydra-window-size (global-map "C-M-o")
    "window size"
    ("h" shrink-window-horizontally "shrink horizontal")
    ("j" enlarge-window "enlarge vertical")
    ("k" shrink-window "shrink vertical")
    ("l" enlarge-window-horizontally "enlarge horizontal")
    ("=" balance-windows "balance")))

(use-package edit-indirect
  :ensure t
  :bind ("C-c '" . edit-indirect-region))

;;; ivy, swiper & counsel

(use-package ivy
  :ensure t
  :commands ivy-switch-buffer
  :bind ("C-c C-r" . ivy-resume)
  :diminish ivy-mode
  :init
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-count-format "%d/%d ")
  (add-hook 'after-init-hook 'ivy-mode))

(use-package swiper
  :ensure t
  :after ivy)

(use-package counsel
  :ensure t
  :after (ivy swiper)
  :bind
  (("C-s" . counsel-grep-or-swiper)
   ("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package saveplace
  :init
  (setq-default save-place t))

(use-package osx-lib
  :if '(eq system-type 'darwin)
  :ensure t)

(use-package restclient
  :ensure t
  :commands restclient-mode)

(use-package company-restclient
  :ensure t
  :after company
  :commands company-restclient
  :init
  (add-hook 'restclient-mode-hook (lambda ()
                                    (kd/local-push-company-backend #'company-restclient))))

(use-package outshine
  :ensure t
  :commands outshine-hook-function
  :init
  (setq outshine-use-speed-commands t)
  (add-hook 'outline-minor-mode-hook 'outshine-hook-function))

(use-package outline
  :commands outline-minor-mode
  :init
  (add-hook 'prog-mode-hook 'outline-minor-mode))

(use-package irfc
  :ensure t
  :commands irfc-mode
  :init
  (setq irfc-directory "~/Documents/rfc/rfc")
  (setq irfc-assoc-mode t))

;;; org-mode

(use-package org
  :bind
  (("C-c c" . org-capture)
   ("C-c b" . org-iswitchb))
  :init
  (setq org-directory "~/Dropbox/org")
  (setq org-default-notes-file (concat org-directory "/cap.org"))
  (setq org-capture-templates
        '(("c" "cap" entry (file "") "* %?\n  %U")))
  (setq org-src-fontify-natively t)
  ;; babel
  (setq org-confirm-babel-evaluate nil)
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
  (org-babel-do-load-languages 'org-babel-load-languages '((ipython . t)
                                                           (shell . t)
                                                           (emacs-lisp . t))))

(use-package org-download
  :ensure t
  :after org)

(use-package ob-ipython
  :ensure t
  :after org)

(use-package ob-async
  :ensure t
  :after org
  :commands ob-async-org-babel-execute-src-block
  :init
  (add-hook 'org-ctrl-c-ctrl-c-hook #'ob-async-org-babel-execute-src-block))

;;; integration

(use-package browse-at-remote
  :ensure t
  :commands browse-at-remote
  :config
  (add-to-list 'browse-at-remote-remote-type-domains '("gitlab.xiaohongshu.com" . "gitlab")))

;;; tags
(use-package counsel-gtags
  :ensure t
  :bind (("C-," . counsel-gtags-find-definition)
         ("C-<" . counsel-gtags-go-backward)))

(use-package ggtags
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'ggtags-mode)
  :config
  (setq ggtags-use-sqlite3 t)
  (setq ggtags-sort-by-nearness t)
  (setq ggtags-highlight-tag nil)
  (setq ggtags-enable-navigation-keys nil))

(use-package imenu-list
  :ensure t
  :bind ("C-'" . imenu-list-smart-toggle))

(use-package imenu-anywhere
  :ensure t
  :bind ("C-." . ivy-imenu-anywhere)
  :config
  ;; only show tag for current buffer
  (setq-default imenu-anywhere-buffer-list-function (lambda () (list (current-buffer))))
  (setq imenu-anywhere-buffer-filter-functions '((lambda (current other) t))))

(use-package company
  :ensure t
  :diminish company-mode
  :commands (company-mode global-company-mode)
  :init
  (add-hook 'after-init-hook #'global-company-mode)
  :config
  (setq tab-always-indent 'complete)
  (defun kd/local-push-company-backend (backend)
    "Add BACKEND to a buffer-local version of `company-backends'."
    (set (make-local-variable 'company-backends)
         (add-to-list 'company-backends backend))))

(use-package company-flx
  :ensure t
  :after company
  :commands company-flx-mode
  :init
  (add-hook 'company-mode-hook #'company-flx-mode))

(use-package paredit
  :ensure t
  :commands paredit-mode
  :diminish paredit-mode
  :init
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode))

(use-package csv-mode
  :ensure t
  :mode ("\\.[Cc][Ss][Vv]\\'" . csv-mode))

(use-package dockerfile-mode
  :ensure t
  :mode ("Dockerfile.*\\'" . dockerfile-mode))

(use-package salt-mode
  :ensure t
  :mode ("\\.sls\\'" . salt-mode))

(use-package apib-mode
  :ensure t
  :commands apib-mode
  :mode ("\\.apib\\'" . apib-mode))

(use-package ansible
  :ensure t
  :commands ansible
  :diminish ansible)

(use-package company-ansible
  :ensure t
  :after company
  :commands company-ansible
  :init
  (add-hook 'ansible::hook (lambda ()
                             (kd/local-push-company-backend #'company-ansible))))

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode))
  :commands (markdown-mode gfm-mode)
  :init
  (setq markdown-command "multimarkdown"))

(use-package conf-mode
  :mode ("rc$" . conf-mode))

(use-package lua-mode
  :ensure t
  :mode ("\\.lua$" . lua-mode)
  :interpreter ("lua" . lua-mode))

(use-package yasnippet
  :ensure t
  :commands yas-global-mode
  :diminish yas-minor-mode
  :init
  (add-hook 'after-init-hook #'yas-global-mode))

(use-package undo-tree
  :ensure t
  :commands undo-tree-mode
  :diminish undo-tree-mode
  :init
  (add-hook 'after-init-hook #'global-undo-tree-mode))

(use-package abbrev
  :defer t
  :diminish abbrev-mode
  :init
  (add-hook 'prog-mode-hook #'abbrev-mode))

(use-package flycheck
  :ensure t
  :commands flycheck-mode
  :diminish flycheck-mode
  :init
  (add-hook 'prog-mode-hook #'flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save)))

(use-package which-func
  :commands which-function-mode
  :init
  (add-hook 'prog-mode-hook #'which-function-mode))

(use-package realgud
  :ensure t
  :commands (realgud:trepan2))


;;; python

(use-package python
  :commands python-mode
  :init
  (defun kd/python-mode-defaults ()
    (subword-mode +1)
    (eldoc-mode 1)
    (when (fboundp 'exec-path-from-shell-copy-env)
      (exec-path-from-shell-copy-env "PYTHONPATH"))
    (setq-local electric-layout-rules
                '((?: . (lambda ()
                          (and (zerop (first (syntax-ppss)))
                               (python-info-statement-starts-block-p)
                               'after)))))
    (add-hook 'post-self-insert-hook #'electric-layout-post-self-insert-function nil 'local))
  (add-hook 'python-mode-hook #'kd/python-mode-defaults))

(use-package pyenv-mode
  :ensure t
  :commands pyenv-mode
  :init
  (add-hook 'python-mode-hook #'pyenv-mode))

(use-package pyenv-mode-auto
  :ensure t
  :after pyenv-mode)

(use-package pip-requirements
  :ensure t
  :defer t)

(use-package jedi-core
  :ensure t
  :commands jedi-mode
  :init
  (setq jedi:use-shortcuts t)
  (add-hook 'python-mode-hook #'jedi:setup))

(use-package company-jedi
  :ensure t
  :commands company-jedi
  :init
  (add-hook 'python-mode-hook (lambda ()
                                (add-to-list 'company-backends #'company-jedi))))

;;; golang
(use-package go-mode
  :ensure t
  :commands go-mode
  :bind
  (:map go-mode-map
        ("M-." . godef-jump)
        ("M-C-." . godef-jump-other-window)
        ("M-k" . godoc-at-point))
  :config
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq gofmt-command "goimports")
  (setq-local flycheck-disabled-checkers '(go-golint)))

(use-package go-eldoc
  :ensure t
  :commands go-eldoc-setup
  :init
  (add-hook 'go-mode-hook #'go-eldoc-setup))

(use-package company-go
  :ensure t
  :after company
  :commands company-go
  :config
  (add-hook 'go-mode-hook (lambda ()
                            (kd/local-push-company-backend #'company-go))))

(use-package go-guru
  :ensure t
  :defer t
  :init
  (add-hook 'go-mode-hook #'go-guru-hl-identifier-mode))

;;; lisp
(use-package elisp-slime-nav
  :ensure t
  :commands turn-on-elisp-slime-nav-mode
  :init
  (add-hook 'emacs-lisp-mode-hook #'turn-on-elisp-slime-nav-mode))


(use-package tldr
  :ensure t
  :commands tldr)

(use-package multi-term
  :ensure t
  :commands multi-term)

(use-package multiple-cursors
  :ensure t)


;; from: http://endlessparentheses.com/the-toggle-map-and-wizardry.html
(defun narrow-or-widen-dwim (p)
  "Widen if buffer is narrowed, narrow-dwim otherwise.
Dwim means: region, org-src-block, org-subtree, or defun,
whichever applies first. Narrowing to org-src-block actually
calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer is
already narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing
         ;; command. Remove this first conditional if you
         ;; don't want it.
         (cond ((ignore-errors (org-edit-src-code))
                (delete-other-windows))
               ((ignore-errors (org-narrow-to-block) t))
               (t (org-narrow-to-subtree))))
        ((derived-mode-p 'latex-mode)
         (LaTeX-narrow-to-environment))
        (t (narrow-to-defun))))

(define-key kd/toggle-map "n" #'narrow-or-widen-dwim)
