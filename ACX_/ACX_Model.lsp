; =========================================================================================== ;
; Obszar modelu / Model space                                                                 ;
; =========================================================================================== ;
(defun cd:ACX_Model ()
  (or
    *cd-ModelSpace*
    (setq *cd-ModelSpace* (vla-get-ModelSpace (cd:ACX_ADoc)))
  )
  *cd-ModelSpace*
)