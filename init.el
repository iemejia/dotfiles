;; Now file is specific for emacs 24
; Specifics for aquamacs
(setq aquamacs-scratch-file "~/Dropbox/Documents/research-notes/scratch.txt")
(if (fboundp 'aquamacs-autoface-mode) (aquamacs-autoface-mode -1))

;; loads scratch file in normal emacs by default like in aquamacs
(setq initial-buffer-choice aquamacs-scratch-file)
(kill-buffer "*scratch*")
;(kill-buffer "*Messages*")

;; to avoid
;; Symbol's value as variable is void: custom-theme-load-path
(setq custom-theme-load-path '())

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'scrollbar-mode) (scrollbar-mode -1))
(setq-default cursor-type 'box) ;; Cursor type 'box 'bar
(defalias 'yes-or-no-p 'y-or-n-p)              ; y/n instead of yes/no
;; Window size
;; (setq default-frame-alist '(
;;                             (width . 80)
;;                             (height . 50)
;;                             ))

;; unfill-region    
(defun unfill-region (beg end)
  "Unfill the region, joining text paragraphs into a single
    logical line.  This is useful, e.g., for use with
    `visual-line-mode'."
  (interactive "*r")
  (let ((fill-column (point-max)))
    (fill-region beg end)))

;; Handy key definition
(define-key global-map "\M-Q" 'unfill-region)

;; sets unicode utf-8 coding system
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment 'utf-8)

; adds support for accents in text files
(add-hook 'text-mode-hook 
  (lambda () (set-input-method "latin-1-prefix")))

(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
  (progn
    ;; use 120 char wide window for largeish displays
    ;; and smaller 80 column windows for smaller displays
    ;; pick whatever numbers make sense for you
    (if (> (x-display-pixel-width) 1280)
        (add-to-list 'default-frame-alist 
                     (cons 'width 80))
;                           (/ (frame-char-width) 3)))
;                           (/ (/ (display-pixel-width) 3) (frame-char-width))))
      (add-to-list 'default-frame-alist (cons 'width 80)))
    ;; for the height, subtract a couple pixels
    ;; from the screen height (for panels, menubars and
    ;; whatnot), then divide by the height of a char to
    ;; get the height we want
    (add-to-list 'default-frame-alist 
         (cons 'height (/ (- (x-display-pixel-height) 50)
                             (frame-char-height)))))))

(set-frame-size-according-to-resolution)


;;
;; Transparency (taken from:
;; https://github.com/jimeh/.emacs.d/blob/master/helpers.el
;;

;; (defun transparency-set-initial-value ()
;;   "Set initial value of alpha parameter for the current frame"
;;   (interactive)
;;   (if (equal (frame-parameter nil 'alpha) nil)
;;       (set-frame-parameter nil 'alpha 100)))

;; (defun transparency-set-value (numb)
;;   "Set level of transparency for the current frame"
;;   (interactive "nEnter transparency level in range 0-100: ")
;;   (if (> numb 100)
;;       (message "Error! The maximum value for transparency is 100!")
;;     (if (< numb 0)
;;         (message "Error! The minimum value for transparency is 0!")
;;       (set-frame-parameter nil 'alpha numb))))

;; (defun transparency-increase ()
;;   "Increase level of transparency for the current frame"
;;   (interactive)
;;   (transparency-set-initial-value)
;;   (if (> (frame-parameter nil 'alpha) 0)
;;       (set-frame-parameter nil 'alpha (+ (frame-parameter nil 'alpha) -1))
;;     (message "This is a minimum value of transparency!")))

;; (defun transparency-decrease ()
;;   "Decrease level of transparency for the current frame"
;;   (interactive)
;;   (transparency-set-initial-value)
;;   (if (< (frame-parameter nil 'alpha) 100)
;;       (set-frame-parameter nil 'alpha (+ (frame-parameter nil 'alpha) +1))
;;     (message "This is a minimum value of transparency!")))

;; ;; Transparency (via helpers.el)
;; (setq transparency-level 85)
;; (transparency-set-value transparency-level)
;; (add-hook 'after-make-frame-functions
;;           (lambda (selected-frame)
;;             (set-frame-parameter selected-frame 'alpha transparency-level)))


;(require 'zoom-frm)

;; use hippie-expand instead of dabbrev
;(global-set-key (kbd "M-/") 'hippie-expand)
;(global-set-key (kbd "s-.") 'dabbrev)

;; Display whitespace characters globally
;;(global-whitespace-mode t)

;; Customize Whitespace Characters
;;  - Newline: \u00AC = ¬
;;  - Tab:     \u25B6 = ▶
;;             \u25B8 = ▸
;; (setq whitespace-display-mappings
;;       (quote ((newline-mark ?\n [?\u00AC ?\n] [?$ ?\n])
;;               (tab-mark     ?\t [?\u25B6 ?\t] [?\u00BB ?\t] [?\\ ?\t]))))

;; (setq whitespace-style
;;       (quote (face tabs trailing space-before-tab newline
;;                    indentation space-after-tab tab-mark newline-mark
;;                    empty)))

;;
;; some keyboard enhancements enhancements
;;
(global-set-key [insert]    'overwrite-mode) ; [Ins] 
(global-set-key [kp-insert] 'overwrite-mode) ; [Ins]
(global-set-key [f1] 'menu-bar-mode)

(require 'recentf)
(recentf-mode 1) ; keep a list of recently opened files
(setq recentf-max-menu-items 25)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; remember location in buffer files
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/saveplace")

;; (require 'undo-tree)
;; (global-undo-tree-mode 1)
;; (global-set-key (kbd "M-z") 'undo) ; 【Ctrl+z】
;; (global-set-key (kbd "M-S-z") 'redo) ; 【Ctrl+Shift+z】

(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

(global-set-key (kbd "C-c C-c") 'comment-dwim-line)

(defun move-text-internal (arg)
   (cond
    ((and mark-active transient-mark-mode)
     (if (> (point) (mark))
            (exchange-point-and-mark))
     (let ((column (current-column))
              (text (delete-and-extract-region (point) (mark))))
       (forward-line arg)
       (move-to-column column t)
       (set-mark (point))
       (insert text)
       (exchange-point-and-mark)
       (setq deactivate-mark nil)))
    (t
     (beginning-of-line)
     (when (or (> arg 0) (not (bobp)))
       (forward-line)
       (when (or (< arg 0) (not (eobp)))
            (transpose-lines arg))
       (forward-line -1)))))

(defun move-text-down (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines down."
   (interactive "*p")
   (move-text-internal arg))

(defun move-text-up (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines up."
   (interactive "*p")
   (move-text-internal (- arg)))

(global-set-key [\M-\S-up] 'move-text-up)
(global-set-key [\M-\S-down] 'move-text-down)

;; Mac OS X specific keybindings
(when (eq system-type 'darwin)

  ;; Undo/Redo (via undo-tree)
  (when (require 'undo-tree nil 'noerror)
    (global-set-key (kbd "s-z") 'undo-tree-undo)
    (global-set-key (kbd "s-Z") 'undo-tree-redo))

  ;; Flyspell correct previous word
  (when (require 'flyspell nil 'noerror)
    (global-set-key (kbd "s-.") 'flyspell-correct-word-before-point))

  ;; Mac OS X Fullscreen (requires this patch: https://gist.github.com/1012927)
  (global-set-key (kbd "s-<return>") 'ns-toggle-fullscreen)

  ;; fix the mac search to be repeated M-g
  (global-set-key (kbd "s-f") 'isearch-forward)
  (add-hook 'isearch-mode-hook
            (lambda ()
              (define-key isearch-mode-map (kbd "s-f") 'isearch-repeat-forward)
              ))

  ;; Move to beginning/end of buffer
  (global-set-key (kbd "s-<up>") 'beginning-of-buffer)
  (global-set-key (kbd "s-<down>") 'end-of-buffer)

  ;; Move to beginning/end of line
  (global-set-key (kbd "s-<left>") 'beginning-of-line)
  (global-set-key (kbd "s-<right>") 'end-of-line)

  (global-set-key (kbd "s-=") 'text-scale-increase)
  (global-set-key (kbd "s--") 'text-scale-decrease)

  (global-set-key (kbd "<M-up>") 'backward-paragraph)
  (global-set-key (kbd "<M-down>") 'forward-paragraph)

  (global-set-key (kbd "s-o") 'find-file)

  (global-set-key (kbd "s-}") 'next-buffer)
  (global-set-key (kbd "s-{") 'previous-buffer)

  ;; mode specific bindings
  (global-set-key (kbd "s-r") 'recentf-open-files)
  (global-set-key (kbd "s-/") 'comment-dwim-line)

  (global-set-key (kbd "<help>") (function overwrite-mode))

)

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
(cond ((= 24 emacs-major-version)
       (load-theme 'sanityinc-tomorrow-night t)))

;; (require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-charcoal-black)))

;perspectives
;; (add-to-list 'load-path "~/.emacs.d/plugins/perspective-el")
;; (require 'perspective)

; log4j-el
(add-to-list 'load-path "~/.emacs.d/plugins/log4j-mode")
(require 'log4j-mode)

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq-default tab-width 4) ;; Default tab-width of 4 spaces
(setq-default indent-tabs-mode nil) ;; Always indent with spaces

(setq indent-line-function 'insert-tab)
(setq inhibit-startup-message t)
(setq vc-follow-symlinks t) ; Avoid confirmation in symlinks edition

(blink-cursor-mode 1) ; blinks cursor
(transient-mark-mode 1) ; highlight text selection
(setq shift-select-mode t) ; “t” for true, “nil” for false
(define-key input-decode-map "\e[1;2A" [S-up]) ; horrible hack for S-up
(delete-selection-mode 1) ; delete seleted text when typing
(show-paren-mode 1) ; turn on paren match highlighting
(global-hl-line-mode 1) ; turn on highlighting current line
(column-number-mode 1) ; show the cursor's column position
(size-indication-mode 1) ; indicates the percentage of the buffer
;; (global-linum-mode 1) ; display line numbers in margin. Emacs 23 only.

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
 
(require 'auto-complete-config)
(ac-config-default)
;(require 'auto-complete-yasnippet)
;(require 'auto-complete-c)
(require 'auto-complete-clang)
;(require 'auto-complete-etags)
;(require 'auto-complete-extension)
;(require 'auto-complete-octave)
;(require 'auto-complete-verilog)

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


(autoload 'glsl-mode "glsl-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.geom\\'" . glsl-mode))

;; Automatically save and restore sessions
(setq desktop-dirname             "~/.emacs.d/desktop/"
      desktop-base-file-name      "emacs.desktop"
      desktop-base-lock-name      "lock"
      desktop-path                (list desktop-dirname)
      desktop-save                t
      desktop-files-not-to-save   "^$" ;reload tramp paths
      desktop-load-locked-desktop nil)
(desktop-save-mode 1)

;; Well, I actually set (desktop-save-mode 0) and then use M-x my-desktop to kick things off:

;; (defun my-desktop ()
;;   "Load the desktop and enable autosaving"
;;   (interactive)
;;   (let ((desktop-load-locked-desktop "ask"))
;;     (desktop-read)
;;     (desktop-save-mode 1)))
