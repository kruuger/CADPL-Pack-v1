; =========================================================================================== ;
; Kolekcja UserCoordinateSystems / UserCoordinateSystems collection                           ;
; =========================================================================================== ;
(defun cd:ACX_UCSs ()
  (or
    *cd-UCSs*
    (setq *cd-UCSs* (vla-get-UserCoordinateSystems (cd:ACX_ADoc)))
  )
  *cd-UCSs*
)