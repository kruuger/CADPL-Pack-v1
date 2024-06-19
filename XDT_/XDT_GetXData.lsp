; =========================================================================================== ;
; Czyta dane dodatkowe XDATA / Reads additional data XDATA                                    ;
;  Ename [ENAME]   - nazwa entycji / entity name                                              ;
;  App   [STR/nil] - nil = dla wszystkich aplikacji / for all applications                    ;
;                    STR = dla aplikacji App / for App application                            ;
; ------------------------------------------------------------------------------------------- ;
; (cd:XDT_GetXData (car (entsel)) "CADPL")                                                    ;
; =========================================================================================== ;
(defun cd:XDT_GetXData (Ename App)
  (if App
    (cadr (assoc -3 (entget Ename (list App))))
    (cdr (assoc -3 (entget Ename (list "*"))))
  )
)