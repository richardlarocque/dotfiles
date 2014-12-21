;; .emacs -- Richard's Emacs dotfile
;;
;;; Commentary:
;; Here's a comment to keep the linter happy.

;;; Code:


(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

(setq my-packages
      '(el-get
        evil evil-leader
        projectile flx
        dedicated
        autopair
        magit
        flycheck let-alist
        flycheck-haskell haskell-mode
        jade-mode js2-mode
        flymake-sass sass-mode
        handlebars-mode haml-mode
        nix-mode))

(el-get 'sync my-packages)

;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;;                          ("org" . "http://orgmode.org/elpa/")
;;                          ("marmalade" . "http://marmalade-repo.org/packages/")
;;                          ("melpa" . "http://melpa.milkbox.net/packages/")))
;; (package-initialize)

;; (ensure-package-initialized
;;  'evil 'evil-leader
;;  'flx-ido
;;  'projectile
;;  'dedicated
;;  'autopair
;;  'magit
;;  'flycheck-haskell 'haskell-mode
;;  'sws-mode 'jade-mode 'js2-mode
;;  'flymake-sass 'sass-mode
;;  'handlebars-mode 'haml-mode
;;  )


(set-face-attribute 'default nil :height 90)
(load-theme 'deeper-blue t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq inhibit-splash-screen t)
(setq column-number-mode t)

(setq make-backup-files nil)

(setq tab-width 8)

(require 'evil)
(evil-mode 1)

(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

; Unbind evil bindings for space and enter.
(defun my-move-key (keymap-from keymap-to key)
     "Moves key binding from one keymap to another, deleting from the old location. "
     (define-key keymap-to key (lookup-key keymap-from key))
     (define-key keymap-from key nil))
   (my-move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
   (my-move-key evil-motion-state-map evil-normal-state-map " ")

;; esc quits
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'keyboard-quit)
; (define-key ido-completion-map [escape] 'ido-exit-minibuffer)

(define-key evil-normal-state-map (kbd "TAB") 'next-error)
(define-key evil-normal-state-map (kbd "<backtab>") 'previous-error)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

; (setq search-exit-option 't)
(setq lazy-highlight-cleanup nil)

(global-set-key [escape] 'evil-exit-emacs-state)

(define-key evil-normal-state-map (kbd "C-r") 'redo)

(add-to-list 'evil-emacs-state-modes 'shell)

(global-evil-leader-mode)
(setq evil-leader/leader ";")

; UI tweaks
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

(require 'autopair)
(autopair-global-mode)

(require 'projectile)
(projectile-global-mode)
(evil-leader/set-key "r" 'projectile-regenerate-tags)
(evil-leader/set-key "s" 'projectile-find-tag)
(evil-leader/set-key "f" 'projectile-find-file)
(evil-leader/set-key "p" 'projectile-switch-project)
(evil-leader/set-key "g" 'projectile-grep)

(setq projectile-switch-project-action 'projectile-dired)

(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

(setq whitespace-style
  (quote (face trailing tab-mark lines-tail)))
(add-hook 'find-file-hook 'whitespace-mode)

; (define-key evil-window-map "I" 'ido-find-buffer-other-window)
; (define-key evil-window-map "i" 'ido-find-file-other-window)
; (define-key ido-completion-map (kbd "S-RET") 'ido-select-text)

(require 'dedicated)
(global-set-key (kbd "C-l") 'dedicated-mode)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(require 'magit)
(delete 'Git vc-handled-backends)

(require 'js2-mode)
(add-hook 'js2-mode-hook
	  (lambda()
	    (setq js-indent-level 2)
	    (setq indent-tabs-mode nil)
	    ))

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))

; ;; ; Jade support
; (require 'jade-mode)
; (add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))
;
; (add-hook 'jade-mode-hook
; 	  (lambda()
; 	    (setq sws-tab-width 2)
; 	    (setq indent-tabs-mode nil)
; 	    ))

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

(custom-set-variables
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t))

(custom-set-variables
 '(haskell-process-type 'ghci)
 '(haskell-notify-p t)
 '(haskell-tags-on-save t)
 '(haskell-stylish-on-save t))

(require 'w3m-load)
(require 'w3m-haddock)
(add-hook 'w3m-display-hook 'w3m-haddock-display)

(evil-define-key 'normal haskell-mode-map (kbd "`") 'haskell-interactive-bring)
(evil-define-key 'insert haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)

(dolist (m '(haskell-mode cabal-mode haskell-interactive-mode))
  (evil-leader/set-key-for-mode m "l" 'haskell-process-load-or-reload)
  (evil-leader/set-key-for-mode m "t" 'haskell-process-do-type)
  (evil-leader/set-key-for-mode m "i" 'haskell-process-do-info)
  (evil-leader/set-key-for-mode m "c" 'haskell-process-cabal)
  (evil-leader/set-key-for-mode m "b" 'haskell-process-cabal-build)
  (evil-leader/set-key-for-mode m "k" 'haskell-process-interactive-mode-clear)
  (evil-leader/set-key-for-mode m "d" 'haskell-w3m-open-haddock))

(evil-define-key 'normal cabal-mode-map (kbd "`") 'haskell-interactive-bring)
(evil-define-key 'normal haskell-interactive-mode (kbd "`") 'bury-buffer)

(add-hook 'after-init-hook #'global-flycheck-mode)

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))

(require 'flymake-sass)
(add-hook 'sass-mode-hook 'flymake-sass-load)
(add-hook 'scss-mode-hook 'flymake-sass-load)

(require 'sass-mode)
(require 'handlebars-mode)
