;; Now file is specific for emacs 24
; Specifics for aquamacs
(setq aquamacs-scratch-file "~/Dropbox/Documents/research-notes/scratch.txt")
(if (fboundp 'aquamacs-autoface-mode) (aquamacs-autoface-mode -1))

;; loads scratch file in normal emacs by default like in aquamacs
(pop-to-buffer (find-file aquamacs-scratch-file))
(end-of-buffer)
(kill-buffer "*scratch*")

;; to avoid
;; Symbol's value as variable is void: custom-theme-load-path
(setq custom-theme-load-path '())

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'scrollbar-mode) (scrollbar-mode -1))
(setq-default cursor-type 'box) ;; Cursor type 'box 'bar
(defalias 'yes-or-no-p 'y-or-n-p)              ; y/n instead of yes/no
;; Window size
(setq default-frame-alist '(
                            (width . 80)
                            (height . 50)
                            ))

;(require 'zoom-frm)

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") 'hippie-expand)

;; Mac OS X specific keybindings
(when (eq system-type 'darwin)

  ;; Mac OS X Fullscreen (requires this patch: https://gist.github.com/1012927)
  (global-set-key (kbd "s-<return>") 'ns-toggle-fullscreen)

  ;; Undo/Redo (via undo-tree)
  (when (require 'undo-tree nil 'noerror)
    (global-set-key (kbd "s-z") 'undo-tree-undo)
    (global-set-key (kbd "s-Z") 'undo-tree-redo))

  ;; Flyspell correct previous word
  (when (require 'flyspell nil 'noerror)
    (global-set-key (kbd "s-.") 'flyspell-correct-word-before-point))

  ;; Move to beginning/end of buffer
  (global-set-key (kbd "s-<up>") 'beginning-of-buffer)
  (global-set-key (kbd "s-<down>") 'end-of-buffer)

  ;; Move to beginning/end of line
  (global-set-key (kbd "s-<left>") 'beginning-of-line)
  (global-set-key (kbd "s-<right>") 'end-of-line)

  (global-set-key (kbd "s-=") 'text-scale-increase)
  (global-set-key (kbd "s--") 'text-scale-decrease)

  (global-set-key (kbd "<M-up>") 'backward-paragraph)
  (global-set-key (kbd "<M-down>") 'forward-paragraph))

;(global-set-key (kbd "s up") 'text-scale-decrease)

;; nice scrolling
;; (setq scroll-margin 0
;;       scroll-conservatively 100000
;;       scroll-preserve-screen-position 1)

;; windows-like scrolling
;; (setq scroll-step 1) 
;; (setq scroll-conservatively 50)

;; some mappings to avoid using backspace
(global-set-key "\C-h" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; ;el-get
;; (add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;; (unless (require 'el-get nil t)
;;   (url-retrieve
;;    "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
;;    (lambda (s)
;;      (end-of-buffer)
;;      (eval-print-last-sexp))))
;; ;(el-get 'sync)

;; make aquamacs use the default package directory ~/.emacs.d/elpa
(setq package-user-dir "~/.emacs.d/elpa")

(setq load-path 
      (cons "~/.emacs.d/elisp" load-path)) 

(require 'package)
;; Marmalade
;; (add-to-list 'package-archives
;;              '("marmalade" . "http://marmalade-repo.org/packages/"))
;; melpa
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; The original ELPA archive still has some useful
;; stuff.
;; (add-to-list 'package-archives<br />
;;              '("elpa" . "http://tromey.com/elpa/"))
(package-initialize)

;; set font
(set-frame-font "Menlo-12")
;(text-scale-increase 1)

;; set theme
;; (cond ((= 24 emacs-major-version)
;;   (load-theme 'sanityinc-tomorrow-night t)))

(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-charcoal-black)))

;perspectives
;; (add-to-list 'load-path "~/.emacs.d/plugins/perspective-el")
;; (require 'perspective)

; (global-set-key [insert]    'overwrite-mode) ; [Ins] 
; (global-set-key [kp-insert] 'overwrite-mode) ; [Ins]

; log4j-el
(add-to-list 'load-path "~/.emacs.d/plugins/log4j-mode")
(require 'log4j-mode)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'insert-tab)
(setq inhibit-startup-message t)
(setq vc-follow-symlinks t) ; Avoid confirmation in symlinks edition

(blink-cursor-mode 0) ; blinks cursor
(transient-mark-mode 1) ; highlight text selection
(setq shift-select-mode t) ; “t” for true, “nil” for false
(define-key input-decode-map "\e[1;2A" [S-up]) ; horrible hack for S-up
(delete-selection-mode 1) ; delete seleted text when typing
(show-paren-mode 1) ; turn on paren match highlighting
(global-hl-line-mode 0) ; turn on highlighting current line
(column-number-mode 1) ; show the cursor's column position
(recentf-mode 1) ; keep a list of recently opened files
(global-set-key (kbd "C-x C-r") 'recentf-open-files)
(size-indication-mode 1) ; indicates the percentage of the buffer
;; (global-linum-mode 1) ; display line numbers in margin. Emacs 23 only.

(require 'undo-tree)
(global-undo-tree-mode 1)
(global-set-key (kbd "M-z") 'undo) ; 【Ctrl+z】
(global-set-key (kbd "M-S-z") 'redo) ; 【Ctrl+Shift+z】

; Associate nfo file suffix with IBM codepage 437 encoding
(setq auto-coding-alist (cons '("\\.nfo\\'" . cp437-dos) auto-coding-alist))

; Use 10-pt Consolas as default font
;; (set-face-attribute 'default nil
;;                     :family "Consolas" :height 100)
;; set-default-font
;;      "-outline-Consolas-normal-r-normal-normal-14-97-96-96-c-*-iso8859-1")

;; (set-face-attribute 'default nil
;;                     :family "Inconsolata" :height 145 :weight 'normal)
;; (set-default-font "Inconsolata-12")
;; monaco

; switch ctrl to be in command
;; (setq mac-control-modifier 'meta)
;; (setq mac-command-modifier 'ctrl)

;; (setq mac-command-modifier 'meta)
;; (setq mac-command-modifier 'ctrl)

;; (setq mac-option-modifier 'meta) - Sets the option key as Meta (this is default)
;; (setq mac-command-modifier 'meta) - Sets the command (Apple) key as Meta
;; (setq mac-control-modifier 'meta) - Sets the control key as Meta
;; (setq mac-function-modifier 'meta) - Sets the function key as Meta (limitations on non-Eng
;; 'meta, ‘alt, ‘hyper, ‘ctrl

; cuda
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c-mode))

; markdown
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
 
;(require 'ctags-update)

;;(load "folding" 'nomessage 'noerror)
;;  (folding-mode-add-find-file-hook)

(require 'auto-complete-config)
(ac-config-default)
;(require 'auto-complete-yasnippet)
;(require 'auto-complete-c)
(require 'auto-complete-clang)
;(require 'auto-complete-etags)
;(require 'auto-complete-extension)
;(require 'auto-complete-octave)
;(require 'auto-complete-verilog)

;;(require 'eassist)


;; configuration for semantic
(require 'semantic)
(semantic-mode 1)

(require 'semantic/bovine/gcc)
;;(semantic-add-system-include "~/exp/include/boost_1_37" 'c++-mode)

(defun nix-setup-auto-complete-semantic ()
  "Arrange to do semantic autocompletion."
;  (add-to-list 'ac-sources 'ac-source-gtags)
  (add-to-list 'ac-sources 'ac-source-semantic))
(add-hook 'c-mode-common-hook 'nix-setup-auto-complete-semantic t)

(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hooks 'my-semantic-hook)

;; enable ctags for some languages:
;;  Unix Shell, Perl, Pascal, Tcl, Fortran, Asm
;;(when (cedet-ectag-version-check)
;;  (semantic-load-enable-primary-exuberent-ctags-support))

(global-ede-mode t)
;;(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
;;(global-srecode-minor-mode 1)            ; Enable template insertion menu

;; Class suggest improvement
(defun my-cedet-hook () 
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-c+" 'semantic-tag-folding-show-block)
  (local-set-key "\C-c-" 'semantic-tag-folding-fold-block)
  (local-set-key ">" 'semantic-complete-self-insert)
  (local-set-key "." 'semantic-complete-self-insert))
(add-hook 'c-mode-common-hook 'my-cedet-hook)

(if (boundp 'semantic-load-enable-excessive-code-helpers)
    ; Add-on CEDET
    (progn
      (semantic-load-enable-excessive-code-helpers)
      ; TODO: should already be enabled by previous line
      (global-semantic-idle-completions-mode)
      (global-semantic-tag-folding-mode))
;;    ; Integrated CEDET
  (setq semantic-default-submodes
        '(global-semanticdb-minor-mode
          global-semantic-idle-scheduler-mode
          global-semantic-idle-summary-mode
          global-semantic-idle-completions-mode
          global-semantic-decoration-mode
          global-semantic-highlight-func-mode
          global-semantic-stickyfunc-mode)))

(if (boundp 'semantic-ia) (require 'semantic-ia))
(if (boundp 'semantic-gcc) (require 'semantic-gcc))
(semantic-gcc-setup)

(setq semanticdb-default-save-directory (expand-file-name "~/.semanticdb")
      semanticdb-default-file-name "semantic.cache"
      semanticdb-default-system-save-directory nil
     semanticdb-default-save-directory nil)

(setq semantic-load-turn-everything-on t)

(global-semantic-idle-completions-mode t)
(global-semantic-decoration-mode t)
(global-semantic-highlight-func-mode t)
(global-semantic-show-unmatched-syntax-mode t)

;; CC-mode
;; (add-hook 'c-mode-hook '(lambda ()
;;         (setq ac-sources (append '(ac-source-semantic) ac-sources))
;;         (local-set-key (kbd "RET") 'newline-and-indent)
;;         (linum-mode t)
;;         (semantic-mode t)))

;;(require 'semantic-tag-folding)
;;(global-semantic-tag-folding-mode 1)

;; (defun c-folding-hook ()
;;   (local-set-key (kbd "C-c <left>") 'semantic-tag-folding-fold-block)
;;   (local-set-key (kbd "C-c <right>") 'semantic-tag-folding-show-block)
;; )
;; (add-hook 'c-mode-common-hook 'c-folding-hook)
