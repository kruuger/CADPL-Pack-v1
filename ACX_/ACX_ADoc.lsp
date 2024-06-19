; =========================================================================================== ;
; Aktywny dokument / Active document                                                          ;
; =========================================================================================== ;
(defun cd:ACX_ADoc ()
  (or
    *cd-ActiveDocument*
    (setq *cd-ActiveDocument* (vla-get-ActiveDocument (vlax-get-acad-object)))
  )
  *cd-ActiveDocument*
)