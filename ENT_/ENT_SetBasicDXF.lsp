; =========================================================================================== ;
; Zmiana podstawowych cech obiektu / Set basic object properties                              ;
;  Ename   [ENAME] - nazwa entycji / entity name                                              ;
;  Layer   [STR]   - nazwa warstwy / layer name                                               ;
;  Color   [INT]   - kolor warstwy / layer color                                              ;
;  LType   [STR]   - typ linii / linetype                                                     ;
;  LScale  [REAL]  - skala linii / linetype scale                                             ;
;  LWeight [INT]   - szerokosc linii / lineweight                                             ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_SetBasicDXF (entlast) "NOWA" 21 "CONTINUOUS" 1.5 13)                                ;
; =========================================================================================== ;
(defun cd:ENT_SetBasicDXF (Ename Layer Color LType LScale LWeight / dt)
  (setq dt (entget Ename))
  (mapcar
    (function
      (lambda (%1 %2)
        (setq dt (if %2
                   (if (not (assoc %1 dt))
                     (append dt (list (cons %1 %2)))
                     (subst
                       (cons %1 %2)
                       (assoc %1 dt)
                       dt
                     )
                   )
                   dt
                 )
        )
      )
    )
    (list 8 62 6 48 370)
    (list Layer Color LType LScale LWeight)
  )
  (entmod dt)
)