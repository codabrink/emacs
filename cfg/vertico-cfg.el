(use-package vertico
  :ensure t
  :init
  (vertico-mode 1)
  :config
  ;; Grow and shrink the minibuffer dynamically
  (setq vertico-resize t
        vertico-count 12))
