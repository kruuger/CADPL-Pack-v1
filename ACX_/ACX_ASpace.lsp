; =========================================================================================== ;
; Aktywny obszar / Active space                                                               ;
; =========================================================================================== ;
(defun cd:ACX_ASpace ()
  (if (= (getvar "CVPORT") 1)
    (vla-item (cd:ACX_Blocks) "*Paper_Space")
    (cd:ACX_Model)
  )
)