;; -*- lexical-binding: t; -*-

(use-package multiple-cursors
  :ensure t
  :config
  ;; Turn off all prompt layers
  (setq mc/always-run-for-all nil)

  ;; The official, correct way to append a single cursor below
  (defun my/mc-add-cursor-below ()
    "Spawns a new cursor on the line below, matching the current column position."
    (interactive)
    (save-excursion
      (let ((col (current-column)))
        ;; Move down to find the target spot
        (forward-line 1)
        (move-to-column col)
        ;; Create a real, independent secondary cursor right there
        (mc/create-fake-cursor-at-point))))

  ;; The official, correct way to append a single cursor above
  (defun my/mc-add-cursor-above ()
    "Spawns a new cursor on the line above, matching the current column position."
    (interactive)
    (save-excursion
      (let ((col (current-column)))
        ;; Move up to find the target spot
        (forward-line -1)
        (move-to-column col)
        ;; Create a real, independent secondary cursor right there
        (mc/create-fake-cursor-at-point))))

  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)))
