; =========================================================================================== ;
; Kolekcja LineTypes / LineTypes collection                                                   ;
; =========================================================================================== ;
(defun cd:ACX_LineTypes ()
  (or
    *cd-LineTypes*
    (setq *cd-LineTypes* (vla-get-LineTypes (cd:ACX_ADoc)))
  )
  *cd-LineTypes*
)