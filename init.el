; Specifics for aquamacs
(setq aquamacs-scratch-file "~/Dropbox/Documents/research-notes/scratch.txt")
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(defalias 'yes-or-no-p 'y-or-n-p)              ; y/n instead of yes/no

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

; color-theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-charcoal-black)

;perspectives
;; (add-to-list 'load-path "~/.emacs.d/plugins/perspective-el")
;; (require 'perspective)

; (global-set-key [insert]    'overwrite-mode) ; [Ins] 
; (global-set-key [kp-insert] 'overwrite-mode) ; [Ins]

; log4j-el
;; (add-to-list 'load-path "~/.emacs.d/plugins/log4j-mode")
;; (require 'log4j-mode)

(setq make-backup-files nil)

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
