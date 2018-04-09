; =========================================================================================== ;
; Kolekcja Blocks / Blocks collection                                                         ;
; =========================================================================================== ;
(defun cd:ACX_Blocks ()
  (or
    *cd-Blocks*
    (setq *cd-Blocks* (vla-get-blocks (cd:ACX_ADoc)))
  )
  *cd-Blocks*
)