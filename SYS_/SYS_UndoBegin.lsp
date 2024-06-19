; =========================================================================================== ;
; Poczatek grupy operacji / Start of group operations                                         ;
; =========================================================================================== ;
(defun cd:SYS_UndoBegin ()
  (cd:SYS_UndoEnd)
  (vla-StartUndoMark (cd:ACX_ADoc))
)