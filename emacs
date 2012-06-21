(setq load-path (cons "~/.emacs.d/" load-path))

(defun insert-header-guard ()
  (interactive)
  (save-excursion
   (when (buffer-file-name)
        (let*
            ((name (file-name-nondirectory buffer-file-name))
             (macro (replace-regexp-in-string
                     "\\." "_"
                     (replace-regexp-in-string
                      "-" "_"
                      (upcase name)))))
          (goto-char (point-min))
          (insert "#ifndef " macro "\n")
          (insert "# define " macro "\n\n")
          (goto-char (point-max))
          (insert "\n#endif\n")))))

;;; =======
;;; OPTIONS
;;; =======
(setq inhibit-startup-message t)        ; don't show the GNU splash screen
(setq frame-title-format "%b")          ; titlebar shows buffer's name
(global-font-lock-mode t)               ; syntax highlighting
(setq font-lock-maximum-decoration t)   ; max decoration for all modes
(setq transient-mark-mode 't)           ; highlight selection
(setq line-number-mode 't)              ; line number
(setq column-number-mode 't)            ; column number
(when (display-graphic-p)               ; if graphic
  (scroll-bar-mode nil)                 ; no scroll bar
  (mouse-wheel-mode t)                  ; enable mouse wheel
  (tool-bar-mode nil)                     ; no tool bar
  )
(menu-bar-mode nil)                     ; no menu bar
(setq scroll-step 1)                    ; smooth scrolling
(setq normal-erase-is-backspace-mode t) ; make delete work as it should
(fset 'yes-or-no-p 'y-or-n-p)           ; 'y or n' instead of 'yes or no'
(setq default-major-mode 'text-mode)    ; change default major mode to text
(setq ring-bell-function 'ignore)       ; turn the alarm totally off
(setq make-backup-files nil)            ; no backupfile
(global-auto-revert-mode t)             ; auto revert modified files
(pc-selection-mode)                     ; selection with shift
(auto-image-file-mode)                  ; to see picture in emacs
(show-paren-mode t)                     ; Paren match highlighting
(add-hook 'write-file-hooks 'delete-trailing-whitespace) ;; Delete trailing whitespaces on save
(setq compilation-window-height 10)     ;; pour que la fenetre de compilation ne soit pas trop grande
(setq compilation-scroll-output t)      ;; va tjs en bas de la fenetre de compile
(setq-default gdb-many-windows t)       ;; Better gdb

;;; ==========
;;;  UNIQUIFY
;;; ==========
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;; ==========
;;;  ENCODING
;;; ==========
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;; ========
;;;  Ispell
;;; ========
(require 'ispell)
(setq ispell-dictionary "francais")
(add-hook 'LaTeX-mode-hook 'flyspell-mode)


;;; ==========================
;;;  Open files/switch buffers
;;; ==========================
(when (string-match "^22." emacs-version)
  (ido-mode t)
  (ido-everywhere t)

  ;; tab means tab, i.e. complete. Not "open this file", stupid.
  (setq ido-confirm-unique-completion t)
  ;; If the file doesn't exist, do try to invent one from a transplanar
  ;; directory. I just want a new file.
  (setq ido-auto-merge-work-directories-length -1)
  ;; Don't switch to GDB-mode buffers (better gdb)
  (setq ido-ignore-buffers (quote ("\\`\\*breakpoints of.*\\*\\'" "\\`\\*stack frames of.*\\*\\'" "\\`\\*gud\\*\\'" "\\`\\*locals of.*\\*\\'" "\\` ")))
  )

;;; ==========================
;;;  Ruby Mode
;;; ==========================
(autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts." t)
(setq auto-mode-alist  (cons '(".rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '(".rhtml$" . html-mode) auto-mode-alist))

;;; ==========================
;;;  Mode Compile
;;; ==========================
(autoload 'mode-compile "mode-compile"
   "Command to compile current buffer file based on the major mode" t)
(global-set-key [(control c) (c)] 'mode-compile)
(autoload 'mode-compile-kill "mode-compile"
 "Command to kill a compilation launched by `mode-compile'" t)
(global-set-key [(control c) (k)] 'mode-compile-kill)

;;; =======
;;; BINDINGS
;;; =======
;; BINDINGS :: isearch

(defun mac-toggle-max-window ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
    (if (frame-parameter nil 'fullscreen)
      nil
      'fullboth)))

(define-key global-map [(M-return)]
  'mac-toggle-max-window)

(global-set-key [(control f)] 'isearch-forward-regexp)  ; search regexp
(global-set-key [(control r)] 'query-replace-regexp)    ; replace regexp
(define-key
 isearch-mode-map
 [(control n)]
 'isearch-repeat-forward)                              ; next occurence
(define-key
 isearch-mode-map
 [(control p)]
 'isearch-repeat-backward)                             ; previous occurence
(define-key
 isearch-mode-map
 [(control z)]
 'isearch-cancel)                                      ; quit and go back to start point
(define-key
 isearch-mode-map
 [(control f)]
 'isearch-exit)                                        ; abort
(define-key
 isearch-mode-map
 [(control r)]
 'isearch-query-replace)                               ; switch to replace mode
(define-key
 isearch-mode-map
 [S-insert]
 'isearch-yank-kill)                                   ; paste
(define-key
 isearch-mode-map
 [(control e)]
 'isearch-toggle-regexp)                               ; toggle regexp
(define-key
 isearch-mode-map
 [(control l)]
 'isearch-yank-line)                                   ; yank line from buffer
(define-key
 isearch-mode-map
 [(control w)]
 'isearch-yank-word)                                   ; yank word from buffer
(define-key
 isearch-mode-map
 [(control c)]
 'isearch-yank-char)                                   ; yank char from buffer

;; BINDINGS :: misc
(if (display-graphic-p)
    (global-set-key [(control z)] 'undo)                ; undo only in graphic mode
)
(global-set-key [C-home] 'beginning-of-buffer)          ; go to the beginning of buffer
(global-set-key [C-end] 'end-of-buffer)                 ; go to the end of buffer
(global-set-key [(meta g)] 'goto-line)                  ; goto line #
(global-set-key [M-left] 'windmove-left)                ; move to left windnow
(global-set-key [M-right] 'windmove-right)              ; move to right window
(global-set-key [M-up] 'windmove-up)                    ; move to upper window
(global-set-key [M-down] 'windmove-down)
(global-set-key [(control tab)] 'other-window)          ; Ctrl-Tab = Next buffer
(global-set-key [C-S-iso-lefttab]
                '(lambda () (interactive)
                   (other-window -1)))                  ; Ctrl-Shift-Tab = Previous buffer
(global-set-key [f12] 'replace-string)
;; BINDINGS :: compile
(global-set-key [f8] 'previous-error)
(global-set-key [f9] 'next-error)
(global-set-key [f10] 'recompile)
(global-set-key [f11] 'compile)
;; BINDINGS :: font size
(global-set-key [(control +)] 'inc-font-size)
(global-set-key [(control =)] 'reset-font-size)
;; BINDINGS :: ido
(global-set-key [(control b)] 'ido-switch-buffer)
;; Autocompletion
(global-set-key [(control return)] 'dabbrev-expand)     ; auto completion
(global-set-key [(control delete)]
                'kill-word)                             ; kill word forward

;;; =======
;;; C HOOKS
;;; =======

;; Delete trailing white spaces
(add-hook 'write-file-hooks 'delete-trailing-whitespace)
;; add header guard
(defun insert-header-guard ()
  (interactive)
  (save-excursion
    (when (buffer-file-name)
      (let*
          (
           (name (file-name-nondirectory buffer-file-name))
           (macro (replace-regexp-in-string "\\." "_" (upcase name)))
           (macro (replace-regexp-in-string "-" "_" macro))
           (macro (concat macro "_"))
           )
        (goto-char (point-min))
        (insert "#ifndef " macro "\n")
        (insert "# define " macro "\n\n")
        (goto-char (point-max))
        (insert "\n#endif /* !" macro " */\n")
        )
      )
    )
  )
; Auto insert C/C++ header guard
(add-hook 'find-file-hooks
          (lambda ()
            (when (and (memq major-mode '(c-mode c++-mode)) (equal (point-min) (point-max)) (string-match ".*\\.hh?" (buffer-file-name)))
              (insert-header-guard)
              (goto-line 3)
              (insert "\n"))))
;; C / C++ mode
(require 'cc-mode)
(add-to-list 'c-style-alist
             '("epita"
               (c-basic-offset . 2)
               (c-comment-only-line-offset . 0)
               (c-hanging-braces-alist     . ((substatement-open before after)))
               (c-offsets-alist . ((topmost-intro        . 0)
                                   (substatement         . +)
                                   (substatement-open    . 0)
                                   (case-label           . +)
                                   (access-label         . -)
                                   (inclass              . ++)
                                   (inline-open          . 0)))))
(setq c-default-style "epita")

;;; =======
;;; ABBREV
;;; =======
;; pabbrev
(load "~/.emacs.d/pabbrev.el")
(require 'pabbrev)
(global-pabbrev-mode)


;;; =======
;;; ENV
;;; =======
(defun build-path-string (pathList)
  "Builds a path string from the given list of path substrings."
  (setq path (car pathList))            ; Extract first path in the list
  (setq pathList (cdr pathList))        ; Rest of the list
  ;; If there's more paths in the list, append the first to the built path
  ;; string of the rest separated with path-separator. The magic of recursion.
  (if pathList
      (concat (concat path path-separator) (build-path-string pathList))
    path)
  )
(setq exec-path (cons "/opt/local/bin" exec-path))
(setenv "PATH" (build-path-string exec-path))


;;; =======
;;; SHELL
;;; =======
(defun insert-shell-shebang ()
  (interactive)
  (when (buffer-file-name)
    (goto-char (point-min))
    (insert "#!/bin/sh\n\n"))
)

;;--------
;; Stuffs
;;--------
(when (display-graphic-p)               ; if graphic
  (set-background-color "black")
  (set-foreground-color "white")
;;  (set-default-font "-misc-fixed-medium-r-normal--13-*-100-100-c-90-iso8859-1")
)

;;----
;; OPA
;;----
(autoload 'opa-js-mode "opa-js-mode.el" "OPA JS editing mode." t)
(autoload 'opa-classic-mode "opa-mode.el" "OPA CLASSIC editing mode." t)
(add-to-list 'auto-mode-alist '("\\.opa$" . opa-js-mode)) ;; <-- Set the default mode here
(add-to-list 'auto-mode-alist '("\\.js\\.opa$" . opa-js-mode))
(add-to-list 'auto-mode-alist '("\\.classic\\.opa$" . opa-classic-mode))


;;----------------
;; Cscope & Ctags
;;----------------
(require 'xcscope)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(show-paren-mode t)
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
