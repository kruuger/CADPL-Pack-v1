; =========================================================================================== ;
; Kolekcja Layouts / Layouts collection                                                       ;
; =========================================================================================== ;
(defun cd:ACX_Layouts ()
  (or
    *cd-Layouts*
    (setq *cd-Layouts* (vla-get-layouts (cd:ACX_ADoc)))
  )
  *cd-Layouts*
)