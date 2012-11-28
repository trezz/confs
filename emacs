;-----------------------------------------------------------------------------;
; Emacs Configuration File						      ;
;									      ;
;	Created by: Vincent Camus <camus.vincent@gmail.com>		      ;
;------------------------------------------------------------------------------

;-----------------;
; General Options ;
;-----------------;

; define the default load path
(setq load-path (cons "~/.emacs.d/" load-path))

; color scheme
(set-background-color "black")
(set-foreground-color "white")

(setq inhibit-startup-message t)	; don't show the GNU splash screen
(setq frame-title-format "%b")		; title bar show buffer's name
(setq font-lock-maximum-decoration t)	; max decoration for all modes
(setq transient-mark-mode t)		; highlight selection
(setq line-number-mode t)		; line number
(setq column-number-mode t)		; column number
(setq scroll-step 1)			; smooth scrolling
(setq make-backup-files nil)		; no backup file

(setq compilation-window-height 10)     ; compile window not too big
(setq compilation-scroll-output t)      ; always on compile window's bottom
(setq-default gdb-many-windows t)       ; better gdb

(when (display-graphic-p)		; if graphic:
  (scroll-bar-mode -1)			;	no scroll bar
  (mouse-wheel-mode t)			;	enable mouse wheel
  (tool-bar-mode -1)			;	no tool bar
)

(menu-bar-mode -1)			; no menu bar
(global-font-lock-mode t)		; syntax highlighting
(fset 'yes-or-no-p 'y-or-n-p)		; 'y or n' instead of 'yes or no'

(show-paren-mode t)			; highlight parenthesis matching

; (uniquify) makes buffers name unique
;-------------------------------------
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)

; (ido) interactively do things with buffers and files
;-----------------------------------------------------
(ido-mode t)
(ido-everywhere t)
; don't switch to GDB-mode buffers (better gdb)
(setq ido-ignore-buffers 
      (quote ("\\`\\*breakpoints of.*\\*\\'" 
	      "\\`\\*stack frames of.*\\*\\'" 
	      "\\`\\*gud\\*\\'" 
	      "\\`\\*locals of.*\\*\\'" 
	      "\\` ")))
;; tab means tab, i.e. complete. Not "open this file", stupid.
(setq ido-confirm-unique-completion t)
; if the file doesn't exist, do try to invent one from a transplanar
; directory. I just want a new file.
(setq ido-auto-merge-work-directories-length -1)

; compile mode
;-------------
(autoload 'mode-compile "mode-compile"
   "Command to compile current buffer file based on the major mode" t)
(autoload 'mode-compile-kill "mode-compile"
 "Command to kill a compilation launched by `mode-compile'" t)

; (cc mode) c / c++ mode
;-----------------------
(require 'cc-mode)
(setq c-default-style "linux"		; linux indentation style
      c-basic-offset 3)				; c indentation offset of 3


; flex
;-----
(require 'flex-mode)

; bison
;------
(require 'bison-mode)

;--------------;
; Key Bindings ;
;--------------;

; search bindings
(global-set-key [(control f)]			; regex search
		'isearch-forward-regexp)
(global-set-key [(control r)]			; regex replace
		'query-replace-regexp)
(define-key isearch-mode-map			; next occurence
  [(control n)]
  'isearch-repeat-forward)
(define-key isearch-mode-map			; previous occurence
  [(control p)]
  'isearch-repeat-backward)
(define-key isearch-mode-map			; quit & go back to start point
  [(control z)]
  'isearch-cancel)
(define-key isearch-mode-map			; abort search
  [(control f)]
  'isearch-exit)                                      
(define-key isearch-mode-map			; switch to replace mode
  [(control r)]
  'isearch-query-replace)

; move into buffers bindings
(global-set-key [C-home] 'beginning-of-buffer)  ; go to the beginning of buffer
(global-set-key [C-end] 'end-of-buffer)         ; go to the end of buffer
(global-set-key [(meta g)] 'goto-line)          ; goto line #
(global-set-key [M-left] 'windmove-left)        ; move to left windnow
(global-set-key [M-right] 'windmove-right)      ; move to right window
(global-set-key [M-up] 'windmove-up)            ; move to upper window
(global-set-key [M-down] 'windmove-down)	; move to bottom window
(global-set-key [(control tab)] 'other-window)  ; Ctrl-Tab = Next buffer
(global-set-key [C-S-iso-lefttab]		; Ctrl-Shift-Tab = Previous buffer
                '(lambda () (interactive)
                   (other-window -1)))
(global-set-key [(control b)]			; (ido) switch buffer
		'ido-switch-buffer)

; edit bindings
(global-set-key [(M-delete)] 'kill-word)	; kill word forward

; compilation bindings
(global-set-key [(control c) (c)] 'mode-compile)
(global-set-key [(control c) (k)] 'mode-compile-kill)
(global-set-key [f9] 'previous-error)
(global-set-key [f10] 'next-error)
(global-set-key [f11] 'recompile)
(global-set-key [f12] 'compile)

;-------;
; Hooks ;
;-------;

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
            (when (and (memq major-mode '(c-mode c++-mode))
		       (equal (point-min) (point-max))
		       (string-match ".*\\.hh?" (buffer-file-name)))
              (insert-header-guard)
              (goto-line 3)
              (insert "\n"))))

(defun compile-window-placement-hook ()
  (when (not (get-buffer-window "*compilation*"))
    (save-selected-window
      (save-excursion
        (let* ((w (split-window-vertically))
               (h (window-height w)))
          (select-window w)
          (switch-to-buffer "*compilation*")
          (shrink-window (- h 10)))))))
(add-hook 'compilation-mode-hook 'compile-window-placement-hook)

;-------;
; Fixes ;
;-------;

; fix the <select> undefined error when using shift+up key
(defadvice terminal-init-xterm
  (after select-shift-up activate) 
  (define-key input-decode-map
    "\e[1;2A"
    [S-up]))
