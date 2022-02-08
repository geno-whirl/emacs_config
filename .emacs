;; Linux keyboard config

(defun bind-altgr()
  (interactive)
  (eshell-command "xmodmap -pke > ~/.xmodmap_original")
  (setq xmodconf "clear Mod5\nclear Mod1\nadd Mod5 = Alt_L\nadd Mod1 = Alt_R")
  (write-region  xmodconf nil "~/.emacs_xmodmap")
  (eshell-command "xmodmap ~/.emacs_xmodmap")
  )
(bind-altgr)

(defun rollback-rebind()
  (interactive)
  (eshell-command "xmodmap ~/.xmodmap_original")
  )

;; https://www.reddit.com/r/emacs/comments/c0kye3/alt_gr_asik_alternative_meta/
;; https://emacs.stackexchange.com/questions/3401/keybindings-with-altgr
;; https://askubuntu.com/questions/813332/how-to-enable-alt-gr-key-as-alt-r-for-emacs-on-ubuntu-16-04



;; ;; OS-specific?

;; (use-package exec-path-from-shell
;;  :ensure t
;;  :config
;;  ( when (memq window-system '(mac ns x))
;;  (exec-path-from-shell-initialize)))
 



;; Initialize package sources

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
    ("org" . "https://orgmode.org/elpa/")
    ("elpa" . "https://elpa.gnu.org/packages/")))

(setq package-enable-at-startup nil)
(package-initialize)
(unless package-archive-contents
    (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
    (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)




;; Visuals

(setq inhibit-startup-message t)

(let ((scratch-buf (get-buffer "*scratch*")))
    (when scratch-buf
	(with-current-buffer scratch-buf
		(erase-buffer)
	    )
	)
    )

(scroll-bar-mode -1)        ;; Disable visible scrollbar
(tool-bar-mode -1)          ;; Disable the toolbar
(tooltip-mode -1)           ;; Disable tooltips
(menu-bar-mode -1)          ;; Disable the menu bar


;;(set-face-attribute 'default nil :font "Fira Code Retina" :height 140)
;;(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 140)
;;(set-face-attribute 'variable-pitch nil :font "SF UI Display" :height 200 :weight 'thin :slant 'oblique)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 1)))
(set-face-attribute 'mode-line nil :height 120)
(set-face-attribute 'mode-line-inactive nil :height 120)

(use-package all-the-icons) ;; first-time: M-x all-the-icons-install-fonts

(use-package doom-themes
    :init (load-theme 'doom-monokai-spectrum t))

(column-number-mode)
(global-display-line-numbers-mode t)


(use-package rainbow-delimiters
    :hook (prog-mode . rainbow-delimiters-mode))

;; (use-package keycast
;;     :config (keycast-mode)
;;     )



;; Navigation utilities

(use-package which-key
    :init (which-key-mode)
    :diminish which-key-mode
    :config (setq which-key-idle-delay 1))

(use-package counsel
    :bind (("M-x" . counsel-M-x)
         ("C-x C-d" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	:map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("M-k" . ivy-next-line)
         ("M-i" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("M-i" . ivy-previous-line)
         ("M-k" . ivy-done)
         ("C-g" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("M-i" . ivy-previous-line)
         ("C-g" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package helm
  :bind
  ("M-y" . 'helm-show-kill-ring)
  ("C-x C-b" . 'helm-buffers-list)
  ("M-k" . helm-next-line)
  ("M-i" . helm-previous-line)
  )

(use-package avy
  :bind ("M-s" . avy-goto-char)
  )

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))



;; Navigation

(use-package evil
    :init
    (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    :config
    (evil-mode 1)
    )

(use-package evil-collection
    :after evil
    :config
    (evil-collection-init))
    
(use-package general
  :config (general-auto-unbind-keys))

(use-package hydra)


;; (general-define-key
;;  "M-k" 'next-line
;;  "M-i" 'previous-line
;;  "M-l" 'forward-char
;;  "M-j" 'backward-char
;;  )

;; (bind-keys*
;;  ("M-k" . next-line)
;;  ("M-i" . previous-line)
;;  ("M-l" . forward-char)
;;  ("M-j" . backward-char)
;;  ("M-u" . move-beginning-of-line)
;;  ("M-o" . move-end-of-line)
;;  ("C-M-k" . forward-paragraph)
;;  ("C-M-i" . backward-paragraph)
;;  ("C-M-j" . backward-word)
;;  ("C-M-l" . forward-word)
;;  ("C-M-u" . beginning-of-buffer)
;;  ("C-M-o" . end-of-buffer)
;;  ("C-u" . scroll-down)
;;  ("C-o" . scroll-up)
;;  ("C-i" . scroll-down-1)
;;  ("C-k" . scroll-up-1)
;;  ("C-f C-k" . windmove-down)
;;  ("C-f C-i" . windmove-up)
;;  ("C-f C-l" . windmove-right)
;;  ("C-f C-j" . windmove-left)
;;  ("C-f C-o" . cycle-buffer)
;;  ("C-f C-u" . cycle-buffer-backward)
;;  )



;; Programs

(use-package elpy
  :init
  (elpy-enable)
  :config
  (setq elpy-rpc-python-command "python3")
  (setq elpy-test-runner 'elpy-test-pytest-runner)
  (setq elpy-test-pytest-runner-command '("py.test" "--pdb"))
  (setq python-shell-interpreter "jupyter"
	python-shell-interpreter-args "console --simple-prompt"
	python-shell-prompt-detect-failure-warning nil)
  (add-to-list 'python-shell-completion-native-disabled-interpreters
	       "jupyter")
  :hook
  (elpy-mode . hs-minor-mode)
  )

(use-package sphinx-doc
  :config
  (setq sphinx-doc-include-types t)
  :hook
  (python-mode-hook . (lambda ()
                                  (require 'sphinx-doc)
                                  (sphinx-doc-mode t)))
  )

(use-package magit)

(use-package forge)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind
  ("C-c r" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Documents/programacion/arara_projects")
    (setq projectile-project-search-path '("~/Documents/programacion/arara_projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; http://ergoemacs.org/emacs/elisp_basics.html




;; Org Mode Configuration

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 2.0)
                  (org-level-2 . 1.8)
                  (org-level-3 . 1.5)
                  (org-level-4 . 1.3)
                  (org-level-5 . 1.2)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "SF UI Display" :weight 'normal :height (cdr face) :foreground "grey"))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

  (setq org-ellipsis " ▾")
  (setq org-hide-emphasis-markers t)
)


(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (efs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  ;; (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))
  (org-bullets-bullet-list '(" " " " " " " " " " " " " ")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))

(setq org-confirm-babel-evaluate nil)

(add-to-list 'org-structure-template-alist '("py" . "src python"))

;; (org-babel-jupyter-override-src-block "python")

;; Keybindings

(general-translate-key
  :states '(normal visual)
  "C-g" "C-h"
  )

(general-define-key
    :states '(normal visual)
    "SPC" 'evil-append
    "C-SPC" 'evil-append
    "k" 'evil-next-line
    "i" 'evil-previous-line
    "j" 'evil-backward-char
    "l" 'evil-forward-char
    "u" 'evil-beginning-of-line
    "o" 'evil-end-of-line
    "C-k" 'forward-paragraph
    "C-i" 'backward-paragraph
    "C-j" 'evil-backward-word-begin
    "C-l" 'evil-forward-word-end
    "C-u" 'evil-goto-first-line
    "C-o" 'evil-goto-line
    "C-y" 'evil-scroll-line-up
    "C-h" 'evil-scroll-line-down
    "y" 'evil-scroll-page-up
    "h" 'evil-scroll-page-down
    "RET" 'evil-open-below  
    "z" 'evil-undo
    "x" 'evil-delete
    "c" 'evil-yank
    "v" 'evil-paste-after
    "<" 'comment-region
    ">" 'uncomment-region
    "F" 'evil-visual-char
    "f" 'evil-visual-line
    "C-F" 'evil-visual-block
    "d" 'swiper
    "s" 'evil-ex
    "a" 'avy-goto-char
    )

(general-define-key
    :states '(insert)
    "S-SPC" 'newline
    "C-SPC" 'evil-normal-state
    "S-<backspace>" 'delete-char
    "M-k" 'evil-next-line
    "M-i" 'evil-previous-line
    "M-j" 'evil-backward-char
    "M-l" 'evil-forward-char
    "M-u" 'evil-beginning-of-line
    "M-o" 'evil-end-of-line
    "M-C-k" 'forward-paragraph
    "M-C-i" 'backward-paragraph
    "M-C-j" 'evil-backward-word-begin
    "M-C-l" 'evil-forward-word-end
    "M-C-u" 'evil-goto-first-line
    "M-C-o" 'evil-goto-line
    )

(use-package windmove)
(use-package cycle-buffer
    :ensure nil
    :load-path "/home/toti/.emacs.d/site-lisp/")

(defhydra hydra-window-control (nil nil)
    "Control window navigation"
    ("w" delete-window "close window")
    ("q" kill-buffer-and-window "kill buffer and close window")
    ("e" delete-other-windows "maximize window")
    ("y" split-window-horizontally "split window vertically")
    ("h" split-window-vertically "split window horizontally")
    ("k" windmove-down "move down")
    ("i" windmove-up "move up")
    ("l" windmove-right "move right")
    ("j" windmove-left "move left")
    ("o" cycle-buffer-permissive "cycle buffer forward")
    ("u" cycle-buffer-backward-permissive "cycle buffer backward")
    ("C-a" nil "finished" :exit t)
  )

(general-define-key
    :states '(normal visual insert emacs)
    :keymaps 'override
    "C-d" (general-simulate-key "C-x")
    "C-f" (general-simulate-key "C-c")
    "M-m" (general-simulate-key "M-x")
    "C-a" '(hydra-window-control/body :which-key "window navigation")
    "C-x C-a" 'keycast-mode
    "C-x C-k" 'kill-current-buffer
    "C-x C-q" 'kill-buffer-and-window
    "C-w C-w" 'evil-window-delete
    "M-<tab>" 'other-window
    "C-<tab>" 'cycle-buffer
    "C-<backtab>" 'cycle-buffer-backward-permissive
    "C-c e" 'magit
    "C-c w" 'dired
    )

(general-define-key
    :states '(normal visual insert)
    :keymaps 'elpy-mode-map
    "C-k" 'elpy-nav-forward-block
    "C-j" 'elpy-nav-backward-indent
    "C-l" 'elpy-nav-forward-indent
    "C-i" 'elpy-nav-backward-block
    "M-j" 'elpy-nav-indent-shift-left
    "M-l" 'elpy-nav-indent-shift-right
    "C-c <tab>" 'elpy-company-backend
    "C-c C-t" (lambda ()
                       (interactive)
                       (let ((current-prefix-arg '(4)))
                         (call-interactively 'compile)))
    "M-d" 'elpy-goto-definition
    "M-D" 'elpy-goto-definition-other-window
    "M-a" 'elpy-folding-toggle-at-point
    "M-f M-f" 'elpy-pdb-toggle-breakpoint-at-point
    "M-f RET" 'elpy-pdb-debug-buffer
    "M-f S-RET" 'elpy-pdb-break-at-point
    "M-f <tab>" 'elpy-pdb-debug-last-exception
    )

(general-define-key
 :states '(normal)
 :keymaps 'dired-mode-map
 "k" 'dired-next-line
 "i" 'dired-previous-line
 "j" 'dired-up-directory
 "l" 'dired-find-file
 "L" 'dired-find-file-other-window
 "u" 'evil-goto-first-line
 "o" 'evil-goto-line
 "g" 'revert-buffer
 "f" 'dired-mark
 "F" 'dired-unmark
 "d" 'dired-flag-file-deletion
 "s" 'dired-goto-file
 "a" 'dired-do-shell-command
 "r" 'dired-do-rename
 "C-x F" 'dired-create-directory
 "x" 'dired-do-delete
 "X" 'dired-do-flagged-delete
 "c" 'dired-do-copy
 )
 
(general-define-key
 :keymaps 'company-active-map
 "M-i" 'company-select-previous
 "M-k" 'company-select-next
 )


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("5b809c3eae60da2af8a8cfba4e9e04b4d608cb49584cb5998f6e4a1c87c057c4" default)))
 '(elpy-test-pytest-runner-command (quote ("py.test")))
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   (quote
    (org-tempo org-tree-slide sphinx-doc evil-magit counsel-projectile projectile keycast general evil helpful ivy-rich rainbow-delimiters doom-modeline cycle-buffer smooth-scroll which-key use-package magit helm exec-path-from-shell elpy counsel ace-window))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'erase-buffer 'disabled nil)
