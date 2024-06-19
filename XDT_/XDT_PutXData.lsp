; =========================================================================================== ;
; Dodaje dane dodatkowe XDATA / Adds additional data XDATA                                    ;
;  Ename [ENAME] - nazwa entycji / entity name                                                ;
;  App   [STR]   - nazwa aplikacji / application name                                         ;
;  Data  [LIST]  - lista danych / data list                                                   ;
; ------------------------------------------------------------------------------------------- ;
; (cd:XDT_PutXData (car (entsel)) "CADPL" '((1000 . "X") (1070 . 5)))                         ;
; =========================================================================================== ;
(defun cd:XDT_PutXData (Ename App Data)
  (regapp App)
  (entmod
    (append
      (entget Ename)
      (list (list -3 (cons App Data)))
    )
  )
)