; =========================================================================================== ;
; Pobiera Xrecord / Gets Xrecord                                                              ;
;  Ename [ENAME] - nazwa entycji / entity name                                                ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCT_GetXrecord (cdar (cd:DCT_GetDictList (cd:DCT_GetDict (namedobjdict) "NAZWA") T)))   ;
; =========================================================================================== ;
(defun cd:DCT_GetXRecord (Ename / dt)
  (cdr (member (assoc 280 (setq dt (entget Ename))) dt))
)