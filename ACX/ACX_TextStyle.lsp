; =========================================================================================== ;
; Kolekcja TextStyles / TextStyles collection                                                 ;
; =========================================================================================== ;
(defun cd:ACX_TextStyles ()
  (or
    *cd-TextStyles*
    (setq *cd-TextStyles* (vla-get-TextStyles (cd:ACX_ADoc)))
  )
  *cd-TextStyles*
)