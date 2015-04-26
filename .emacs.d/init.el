;; Now file is specific for emacs 24
; Specifics for aquamacs
(setq aquamacs-scratch-file "~/Dropbox/Documents/research-notes/scratch.md")
(if (fboundp 'aquamacs-autoface-mode) (aquamacs-autoface-mode -1))

;; loads scratch file in normal emacs by default like in aquamacs
(setq initial-buffer-choice aquamacs-scratch-file)
(kill-buffer "*scratch*")
;(kill-buffer "*Messages*")

;; to avoid
;; Symbol's value as variable is void: custom-theme-load-path
(setq custom-theme-load-path '())

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; (if (fboundp 'menu-bar-mode) (menu-bar-mode -1)) ; since menubar is not intrussive in mac or ubuntu
(if (fboundp 'scrollbar-mode) (scrollbar-mode -1))
(setq-default cursor-type 'box) ;; Cursor type 'box 'bar
(defalias 'yes-or-no-p 'y-or-n-p)              ; y/n instead of yes/no
;; Window size
;; (setq default-frame-alist '(
;;                             (width . 80)
;;                             (height . 50)
;;                             ))


;; rotate through valid buffers
(defun next-user-buffer ()
  "Switch to the next user buffer.
User buffers are those whose name does not start with *."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
      (setq i (1+ i)) (next-buffer) )))

(defun previous-user-buffer ()
  "Switch to the previous user buffer.
User buffers are those whose name does not start with *."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
      (setq i (1+ i)) (previous-buffer) )))

(defun next-emacs-buffer ()
  "Switch to the next emacs buffer.
Emacs buffers are those whose name starts with *."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (not (string-match "^*" (buffer-name))) (< i 50))
      (setq i (1+ i)) (next-buffer) )))

(defun previous-emacs-buffer ()
  "Switch to the previous emacs buffer.
Emacs buffers are those whose name starts with *."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (not (string-match "^*" (buffer-name))) (< i 50))
      (setq i (1+ i)) (previous-buffer) )))

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
(require 'iso-transl)

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
  ;; (global-set-key (kbd "s-f") 'isearch-forward)
  ;; (add-hook 'isearch-mode-hook
  ;;           (lambda ()
  ;;             (define-key isearch-mode-map (kbd "s-f") 'isearch-repeat-forward)
  ;;             ))

  ;; Move to beginning/end of buffer
  (global-set-key (kbd "M-<up>") 'beginning-of-buffer)
  (global-set-key (kbd "M-<down>") 'end-of-buffer)

  ;; Move to beginning/end of line
  (global-set-key (kbd "s-<left>") 'beginning-of-line)
  (global-set-key (kbd "s-<right>") 'end-of-line)

  (global-set-key (kbd "s-=") 'text-scale-increase)
  (global-set-key (kbd "s--") 'text-scale-decrease)

  (global-set-key (kbd "s-<up>") 'backward-paragraph)
  (global-set-key (kbd "s-<down>") 'forward-paragraph)

  ;; mode specific bindings
  (global-set-key (kbd "s-/") 'comment-dwim-line)

  ;; move among windows with the arrows
  (global-set-key (kbd "M-s-<up>") 'other-window)
  (global-set-key (kbd "M-s-<down>") 'other-window)

  (global-set-key (kbd "<help>") (function overwrite-mode))

  ;; inspired by ergomacs
  (global-set-key (kbd "s-3") 'delete-other-windows)
  (global-set-key (kbd "s-4") 'split-window-vertically)
  (global-set-key (kbd "s-5") 'split-window-horizontally)

  (defun delete-word (arg)
    "Delete characters forward until encountering the end of a word.
With argument, do this that many times."
    (interactive "p")
    (delete-region (point) (progn (forward-word arg) (point))))

  (defun backward-delete-word (arg)
    "Delete characters backward until encountering the end of a word.
With argument, do this that many times."
    (interactive "p")
    (delete-word (- arg)))

  (global-set-key (kbd "s-e") 'backward-delete-word)
  ;; (global-set-key (kbd "s-r") 'delete-word)
  ;; (global-set-key (kbd "s-d") 'delete-backward-char)

  (global-set-key (kbd "s-f") 'isearch-forward) 
  (add-hook 'isearch-mode-hook
	    (lambda ()
	      (define-key isearch-mode-map (kbd "s-f") 'isearch-repeat-forward)
	      )
	    )

  (global-set-key (kbd "s-r") 'isearch-backward) 
  (add-hook 'isearch-mode-hook
	    (lambda ()
	      (define-key isearch-mode-map (kbd "s-r") 'isearch-repeat-backward)
	      )
	    )

  (global-set-key (kbd "s-u") 'backward-word)
  (global-set-key (kbd "s-o") 'forward-word)
  (global-set-key (kbd "s-U") 'backward-paragraph)
  (global-set-key (kbd "s-O") 'forward-paragraph)

  (global-set-key (kbd "s-h") 'beginning-of-line)
;;  (global-set-key (kbd "s-H") 'end-of-line)
  (global-set-key (kbd "s-;") 'end-of-line)

  ;; define the function to kill the characters from the cursor 
  ;; to the beginning of the current line
  (defun backward-kill-line (arg)
    "Kill chars backward until encountering the end of a line."
    (interactive "p")
    (kill-line 0))

  (global-set-key (kbd "s-g") 'kill-line)
  (global-set-key (kbd "s-G") 'backward-kill-line)

  (global-set-key (kbd "s-i") 'previous-line)
  (global-set-key (kbd "s-j") 'backward-char)
  (global-set-key (kbd "s-k") 'next-line)
  (global-set-key (kbd "s-l") 'forward-char)

  (global-set-key (kbd "s-I") 'scroll-up-command)
  (global-set-key (kbd "s-J") 'beginning-of-buffer)
  (global-set-key (kbd "s-K") 'scroll-down-command)
  (global-set-key (kbd "s-L") 'end-of-buffer)

  ;; non standard with mac
  (global-set-key (kbd "s-q") 'unfill-paragraph)
 ;;  (global-set-key (kbd "s-Q") 'unfill-paragraph)

  (global-set-key (kbd "s-}") 'previous-user-buffer)
  (global-set-key (kbd "s-{") 'next-user-buffer)
  (global-set-key (kbd "s-]") 'previous-user-buffer)
  (global-set-key (kbd "s-[") 'next-user-buffer)

  ;; my own ideas
  (global-set-key (kbd "s-1") 'kill-this-buffer)
  (global-set-key (kbd "s-2") 'find-file)

  ;; f* keys
  (global-set-key (kbd "<f1>") 'recentf-open-files)
  (global-set-key (kbd "<f2>") 'find-file)
  (global-set-key (kbd "<f3>") 'delete-other-windows)
  (global-set-key (kbd "<f4>") 'split-window-vertically)
  (global-set-key (kbd "s-<f4>") 'save-buffers-kill-emacs)
  (global-set-key (kbd "<f5>") 'split-window-horizontally)
  (global-set-key (kbd "<f6>") 'new-frame)
  (global-set-key (kbd "<f7>") 'previous-user-buffer)
  (global-set-key (kbd "<f9>") 'next-user-buffer)

  (global-set-key (kbd "s-<f7>") 'other-window)
  (global-set-key (kbd "s-<f9>") 'other-window)

  (global-set-key (kbd "s-7") 'beginning-of-line)
  (global-set-key (kbd "s-9") 'end-of-line)

  (global-set-key (kbd "s-n") 'keyboard-escape-quit)
  (global-set-key (kbd "s-t") 'new-frame)
  (global-set-key (kbd "s-§") 'other-frame)
  ;; C-<S-N>
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

;; small hack to add package.el for emacs 23 (for old systems compatibilit)
(when (= emacs-major-version 23)
  (add-to-list 'load-path "~/.emacs.d/elisp23/")
  )

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

;; refresh package list (and creates in case it doesn't exist
(when (not package-archive-contents) (package-refresh-contents))

;; check if the packages is installed; if not, install it.
(mapc
 (lambda (package)
   (or (package-installed-p package)
       ;; (if (y-or-n-p (format "Package %s is missing. Install it? " package))
	   (package-install package)))
 '(auctex markdown-mode color-theme color-theme-sanityinc-solarized color-theme-sanityinc-tomorrow base16-theme bash-completion auto-complete powerline popup undo-tree evil evil-indent-textobject org))

;; a first trial to do auto upgrade of packages
;; (package-menu-mark-upgrades)
;; (package-menu-execute)

;; set font
;; (set-frame-font "Menlo-12")
;(text-scale-increase 1)

;; set theme
(require 'color-theme)
(require 'color-theme-sanityinc-tomorrow)
;;(require 'base16-tomorrow-theme)
;;(require 'powerline)
;;(powerline-default-theme)

(if (= 24 emacs-major-version)
    (load-theme 'sanityinc-tomorrow-night t)
  (progn (color-theme-initialize) (color-theme-sanityinc-tomorrow-night)))

;; (require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-charcoal-black)))

;perspectives
;; (add-to-list 'load-path "~/.emacs.d/plugins/perspective-el")
;; (require 'perspective)

; log4j-el
;; (add-to-list 'load-path "~/.emacs.d/plugins/log4j-mode")
;; (require 'log4j-mode)

; ess
;; (require 'ess-site)
;; (add-to-list 'auto-mode-alist '("\\.R\\'" . R-mode))
;; (add-to-list 'auto-mode-alist '("\\.r\\'" . R-mode))
; (setq ess-ask-about-transfile t)

; start server
(require 'server)
(load "server")
(unless (server-running-p) (server-start))

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
;; (set-default-)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; configuration for latexmk support

;; The following only works with AUCTeX loaded
(require 'tex-site)

(setenv "PATH" 
        (concat "/usr/texbin" ":" (getenv "PATH")))

;; Use PDF mode by default
(setq-default TeX-PDF-mode t)
;; Make emacs aware of multi-file projects
(setq-default TeX-master "main") ; normally nil is interactive

;; make latexmk available via C-c C-c
;; Note: SyncTeX is setup via ~/.latexmkrc (see below)
(add-hook 'LaTeX-mode-hook (lambda ()
  (push
    '("latexmk" "latexmk -pvc -pdf %s" TeX-run-TeX nil t ; %s
      :help "Run latexmk on file")
    TeX-command-list)))
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))

;; use Skim as default pdf viewer
;; Skim's displayline is used for forward search (from .tex to .pdf)
;; option -b highlights the current line; option -g opens Skim in the background  
(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
     '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))

(add-hook 'LaTeX-mode-hook
          (lambda () (local-set-key (kbd "<S-s-mouse-1>") #'TeX-view))
          )

;; Python - Jedi
;; (setenv "PATH" 
;;         (concat "/opt/local/bin" ":" (getenv "PATH")))

;; (autoload 'jedi:setup "jedi" nil t)
;; (setq jedi:setup-keys t)

;; (add-hook 'python-mode-hook
;; (lambda ()
;; (jedi:setup)
;; ))

;; for calibre recipes
(add-to-list 'auto-mode-alist '("\\.recipe\\'" . python-mode))

;; elpy
;; (elpy-enable)

;; quiet, please! No dinging!
(setq visible-bell t)
;; (setq ring-bell-function `(lambda ()
;;   (set-face-background 'default "DodgerBlue")
;;   (set-face-background 'default "black")))

;; evil mode
(require 'evil)
(evil-mode 1)

; some keymaps from ~/.vimrc
;; (define-key evil-insert-state-map [f1] 'save-buffer) ; save
;; (define-key evil-normal-state-map [f1] 'save-buffer) ; save
(define-key evil-normal-state-map ",w" 'save-buffer) ; save
(define-key evil-normal-state-map ",q" 'kill-buffer) ; quit
(define-key evil-normal-state-map ",x" 'save-buffers-kill-emacs) ; save and quit
(define-key evil-normal-state-map (kbd "<SPC>") 'evil-search-forward) ; search next
(define-key evil-motion-state-map (kbd "C-SPC") 'evil-search-backward) ; search previous

;; defines 'kj' combination same as <ESC> 
(define-key evil-insert-state-map "k" #'cofi/maybe-exit)

(evil-define-command cofi/maybe-exit ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "k")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
               nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?j))
    (delete-char -1)
    (set-buffer-modified-p modified)
    (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                          (list evt))))))))

;; disable arrows
;; (define-key evil-insert-state-map [left] 'undefined)
;; (define-key evil-insert-state-map [right] 'undefined)
;; (define-key evil-insert-state-map [up] 'undefined)
;; (define-key evil-insert-state-map [down] 'undefined)

;; (define-key evil-motion-state-map [left] 'undefined)
;; (define-key evil-motion-state-map [right] 'undefined)
;; (define-key evil-motion-state-map [up] 'undefined)
;; (define-key evil-motion-state-map [down] 'undefined)

;; Remap VIM 0 to first non-blank character
(evil-redirect-digit-argument evil-motion-state-map "0" 'evil-first-non-blank)

;; Make Y consistent with C and D.  See :help Y. nnoremap Y y$
(define-key evil-normal-state-map "Y" (kbd "y$"))

;; del key mapping (del apparently is mapped to C-d, and C-d to scroll down)
(define-key evil-normal-state-map "\C-d" 'evil-delete-char)
(define-key evil-insert-state-map "\C-d" 'evil-delete-char)
(define-key evil-visual-state-map "\C-d" 'evil-delete-char)

;; (define-key key-translation-map (kbd "ch") (kbd "C-h"))
;; todo c-j to move among frames

;; support copy paste in ubuntu
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;; ido-mode
(require 'ido)
(ido-mode t)

