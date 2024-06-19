; =========================================================================================== ;
; Usuwa dane dodatkowe XDATA / Removes additional data XDATA                                  ;
;  Ename [ENAME] - nazwa entycji / entity name                                                ;
;  App   [STR]   - nil = z wszystkich aplikacji / from all applications                       ;
;                  STR = z aplikacji App / from App application                               ;
; ------------------------------------------------------------------------------------------- ;
; (cd:XDT_RemoveXData (car (entsel)) "CADPL")                                                 ;
; =========================================================================================== ;
(defun cd:XDT_RemoveXData (Ename App)
  (if
    (and
      App
      (cd:XDT_GetXData Ename App)
    )
    (entmod (list (cons -1 Ename) (list -3 (list App))))
    (foreach %
      (mapcar
        (quote car)
        (cd:XDT_GetXData Ename nil)
      )
      (entmod (list (cons -1 Ename) (list -3 (list %))))
    )
  )
)