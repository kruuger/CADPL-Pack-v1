; =========================================================================================== ;
; Kolekcja Layers / Layers collection                                                         ;
; =========================================================================================== ;
(defun cd:ACX_Layers ()
  (or
    *cd-Layers*
    (setq *cd-Layers* (vla-get-Layers (cd:ACX_ADoc)))
  )
  *cd-Layers*
)