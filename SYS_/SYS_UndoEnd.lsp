; =========================================================================================== ;
; Koniec grupy operacji / End of group operations                                             ;
; =========================================================================================== ;
(defun cd:SYS_UndoEnd ()
  (if (= 8 (logand 8 (getvar "UNDOCTL")))
    (vla-EndUndoMark (cd:ACX_ADoc))
  )
)