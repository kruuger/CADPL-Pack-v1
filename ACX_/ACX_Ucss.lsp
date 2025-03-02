; =========================================================================================== ;
; Kolekcja Ucss / Ucss collection                                                             ;
; =========================================================================================== ;
(defun cd:ACX_Ucss () 
  (or 
    *cd-Ucss*
    (setq *cd-Ucss* (vla-get-UserCoordinateSystems (cd:ACX_ADoc)))
  )
  *cd-Ucss*
)