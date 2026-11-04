;; -*- lexical-binding: t; -*-

;; ==========================================
;; 1. ORG-MODERN VISUAL STYLING
;; ==========================================
(use-package org-modern
  :ensure t
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :config
  (setq
   ;; Subtle line padding for a breathable outliner layout
   org-modern-line-spacing 0.2
   
   ;; Table styling (nil keeps clean standard text tables)
   org-modern-table nil
   
   ;; Custom minimalist icons for checkboxes
   org-modern-checkbox '((?X . "☒")
                         (?- . "◫")
                         (?\s . "☐"))

   ;; Beautiful Unicode bullet cycling for nested plain lists
   org-modern-list '((?- . "•")   ; Level 1
                     (?+ . "◦")   ; Level 2
                     (?* . "▪"))  ; Level 3

   ;; Sleek minimalist symbols for Header nodes (replaces raw stars)
   org-modern-star '("◉" "○" "✸" "✿" "❃")

   ;; Clean styling badges for tags, priority ratings, and TODO keywords
   org-modern-tag t
   org-modern-priority t
   org-modern-todo t))

;; Ensure the org-modern styled elements scale perfectly with your font
(custom-set-faces
 '(org-modern-symbol ((t :height 1.1 :weight regular))))

;; ==========================================
;; 2. CORE ORG MODE ENGINE OPTIONS
;; ==========================================
(use-package org
  :config
  (setq org-auto-align-tags nil
        org-tags-column 0
        org-catch-invisible-edits 'show-and-error
        org-special-ctrl-a/e t
        org-insert-heading-respect-content t
        org-hide-emphasis-markers t   ; Automatically hides /italics/ and *bold* syntax characters
        org-pretty-entities t
        org-agenda-tags-column 0
        org-ellipsis "…"
        org-return-follows-link t     ; Hitting Enter on links follows them immediately
        org-startup-indented t        ; Sets up indentation frameworks on file load
        org-fontify-quote-and-verse-blocks t
        
        ;; OPTIMIZATION: Silently auto-create & insert unique IDs on any headline 
        ;; when using standard org-store-link (C-c l) / org-insert-link (C-c C-l)
        org-id-link-to-org-use-id t))

;; Automatically visually nests and step-indents your outliner headers
(add-hook 'org-mode-hook 'org-indent-mode)

;; Quick Shortcut: Press C-c q to instantly drop or wrap a styled quote block
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c q") 
              (lambda () (interactive) (org-insert-structure-template "quote"))))

;; ==========================================
;; 3. THEOLOGY QUOTE BLOCK STYLING (VERIFIED)
;; ==========================================
;; Safe typographic look using beautiful font styling and background tints
(with-eval-after-load 'org
  (custom-set-faces
   '(org-quote ((t :inherit variable-pitch   ; Shunts text to your clean system proportional font
                   :slant italic             ; Book italics style
                   :height 1.15              ; Sizes font up slightly to separate it from lists
                   :background "#1e222a"     ; Subtly dark background block tint for deep contrast
                   :foreground "#ecc37b"     ; Warm, readable scriptural amber gold text
                   :extend t)))))            ; Extends background edge-to-edge

;; ==========================================
;; 4. ORG-ROAM (Logseq-Style Database Integration)
;; ==========================================
(use-package org-roam
  :ensure t
  :init
  ;; Create the folder path safely before the package config executes
  (let ((roam-dir (expand-file-name "~/Documents/org/roam")))
    (unless (file-directory-p roam-dir)
      (make-directory roam-dir t)))
  :custom
  ;; Reverted back to your working custom string block setup
  (org-roam-directory "~/Documents/org/roam")
  (org-roam-verbose nil)
  :bind (("C-c n f" . org-roam-node-find)   ; Find or Create a page
         ("C-c n i" . org-roam-node-insert) ; Link a page inline
         ("C-c n r" . org-roam-buffer-toggle)) ; Toggle Backlinks sidebar panel
  :config
  ;; Automatically updates the cache database index when files are saved
  (org-roam-db-autosync-mode))

;; ==========================================
;; 5. ORG-ROAM-UI (Logseq Visual Graph View)
;; ==========================================
(use-package org-roam-ui
  :ensure t
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t            
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))

;; ==========================================
;; 6. CONSULT-ORG-ROAM (Fuzzy Search Text Inside Notes)
;; ==========================================
(use-package consult-org-roam
  :ensure t
  :after org-roam
  :init
  (consult-org-roam-mode 1)
  :bind (("C-c n s" . consult-org-roam-search))) ; Search text body across all nodes

;; ==========================================
;; 7. ORG-APPEAR (Show Formatting Tokens On Cursor)
;; ==========================================
(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autolinks t       ; Shows full bracket path when cursor hits a [[link]]
        org-appear-autosubmarkers t
        org-appear-trigger 'on-alignment)) ; OPTIMIZATION: Prevents visual jitter while fast-scrolling

;; ==========================================
;; 8. NAVIGATION HISTORIES (Jump Back After Following Link)
;; ==========================================
;; Allows you to instantly jump back to your previous note after following a link
(global-set-key (kbd "C-c n b") #'org-mark-ring-goto)

;; ==========================================
;; 9. DYNAMIC HEADING SCALING (FONTS & SIZES)
;; ==========================================
;; Apply proportional sizes and weights to your outliner levels
(with-eval-after-load 'org
  (custom-set-faces
   '(org-level-1 ((t :height 1.35 :weight bold :foreground "#51afef")))    ; Main Node (Large)
   '(org-level-2 ((t :height 1.20 :weight bold :foreground "#98be65")))    ; Sub-Node
   '(org-level-3 ((t :height 1.10 :weight semi-bold :foreground "#c678dd"))) ; Detail Node
   '(org-level-4 ((t :height 1.00 :weight regular :foreground "#da8548"))))) ; Deep Node (Text Size)

;; ==========================================
;; 10. ROAM-BLOCK (Failsafe Direct GitHub Fetch)
;; ==========================================
;; Safely clones and provisions roam-block without breaking the rest of your system
(let ((roam-block-src-dir (expand-file-name "~/.emacs.d/straight/repos/roam-block/")))
  ;; If the folder doesn't exist, safely make it and clone it via standard Git
  (unless (file-directory-p roam-block-src-dir)
    (make-directory (file-name-directory roam-block-src-dir) t)
    (shell-command (concat "git clone https://github.com " 
                           (shell-quote-argument roam-block-src-dir))))
  
  ;; Safely inject into load path and load if the files downloaded successfully
  (when (file-exists-p (expand-file-name "roam-block.el" roam-block-src-dir))
    (add-to-list 'load-path roam-block-src-dir)
    (require 'roam-block)
    (roam-block-mode 1)
    (setq roam-block-home (list (expand-file-name "~/Documents/org/roam"))
          roam-block-ref-highlight t
          roam-block-embed-highlight t)
    (global-set-key (kbd "C-c b s") #'roam-block-ref-store)
    (global-set-key (kbd "C-c b i") #'roam-block-ref-insert)))
