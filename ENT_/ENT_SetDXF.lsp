; =========================================================================================== ;
; Zmiana danych DXF obiektu / Set the DXF data of object                                      ;
;  Ename [ENAME] - nazwa entycji / entity name                                                ;
;  Code  [INT]   - kod pary DXF / code of dotted pair                                         ;
;  Val   [LIST/INT/REAL/STR/ENAME] - wartosc / value                                          ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_SetDXF (entlast) 70 129)                                                            ;
; =========================================================================================== ;
(defun cd:ENT_SetDXF (Ename Code Val / dt new)
  (setq new (if (not (assoc Code (setq dt (entget Ename))))
              (append dt (list (cons Code Val)))
              (subst
                (cons Code Val)
                (assoc Code dt)
                dt
              )
            )
  )
  (entmod new)
)