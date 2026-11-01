;; -*- lexical-binding: t; -*-


;; Visual tweaks
(setq warning-minimum-level :error)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-visual-line-mode t) ;; Line wrap.

;; Initialize the package manager with correct repository paths
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

;; Fetch the archive description if it's missing
(unless package-archive-contents
  (package-refresh-contents))

;; Enable use-package and ensure packages install automatically
(require 'use-package)
(setq use-package-always-ensure t)

(defun open-my-file (&optional file-path)
  "Instantly opens an initialization file. 
Defaults to `user-init-file` (~/.config/emacs/init.el) if FILE-PATH is not provided."
  (interactive)
  (let ((target-file (or file-path user-init-file)))
    (find-file target-file)))

;; Global quick-access hotkeys
(global-set-key (kbd "C-c e i") #'open-my-file)
(global-set-key (kbd "C-c e o") (lambda () (interactive) (open-my-file "~/Documents/org/main.org")))

;; Add the custom config directory to Emacs's search path
(add-to-list 'load-path (expand-file-name "cfg" user-emacs-directory))

;; Load external configuration files
(load "theme-cfg" :noerror)
(load "org-cfg" :noerror)
(load "mc-cfg" :noerror)
(load "vertico-cfg" :noerror)

(use-package projectile)

;; Make all minibuffer completions completely case-insensitive
(setq read-file-name-completion-ignore-case t   ; Case-insensitive file paths
      read-buffer-completion-ignore-case t     ; Case-insensitive buffer names
      completion-ignore-case t)                 ; Case-insensitive general prompts

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(multiple-cursors org-roam projectile vertico zenburn-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t :height 1.35 :weight bold :foreground "#51afef")))
 '(org-level-2 ((t :height 1.2 :weight bold :foreground "#98be65")))
 '(org-level-3 ((t :height 1.1 :weight semi-bold :foreground "#c678dd")))
 '(org-level-4 ((t :height 1.0 :weight regular :foreground "#da8548")))
 '(org-modern-symbol ((t :height 1.1 :weight regular)) t)
 '(org-quote ((t :inherit variable-pitch :slant italic :height 1.15 :background "#1e222a" :foreground "#ecc37b" :extend t))))
