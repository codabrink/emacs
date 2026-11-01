;; -*- lexical-binding: t; -*-

;; ==========================================
;; Rust Development Configuration
;; ==========================================

;; 1. Core Rust and Tree-sitter Setup
(use-package rust-mode
  :ensure t
  :init
  ;; Remap standard rust-mode to the Tree-sitter variant if available (Emacs 29+)
  (when (fboundp 'rust-ts-mode)
    (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode)))
  :config
  ;; Custom settings for rust-mode
  (setq rust-format-on-save t))

;; 2. LSP Support via Eglot (Built-in)
(use-package eglot
  :ensure nil ; Built-in, do not try to download from MELPA
  :hook
  ((rust-mode . eglot-ensure)
   (rust-ts-mode . eglot-ensure))
  :config
  ;; Performance tweak: increase the amount of data Emacs reads from processes
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  
  ;; Auto-format code buffer via LSP before saving
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'eglot-format nil t))))

;; 3. Code Completion (Corfu)
;; Since you use Vertico for minibuffer completion, Corfu is its sister package
;; providing high-performance, lightweight popup completion in the code buffer.
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t                 ; Enable auto-completion popups
        corfu-auto-delay 0.1         ; Short delay for snappier popups
        corfu-auto-prefix 1          ; Complete after 1 character
        corfu-quit-no-match 'separator))

;; 4. Inline Diagnostics & Lints (Flymake)
(use-package flymake
  :ensure nil ; Built-in
  :bind (:map flymake-mode-map
              ("M-n" . flymake-goto-next-error)
              ("M-p" . flymake-goto-prev-error)))

(use-package treesit
  :ensure nil ; Built-in
  :config
  ;; Tell Emacs where to download the C sources for compilation
  (setq treesit-language-source-alist
        '((rust "https://github.com")))

  ;; Automatically download and compile the grammar if it's missing
  (unless (treesit-ready-p 'rust)
    (treesit-install-language-grammar 'rust)))


(provide 'rust-cfg)
