; =========================================================================================== ;
; Tworzy obiekt typu XLINE / Creates a XLINE object                                           ;
;  Layout [STR]       - nazwa arkusza / layout tab name                                       ;
;  Ps     [LIST]      - punkt poczatkowy / start point                                        ;
;  Pe     [LIST/REAL] - punkt koncowy lub kat w radianach / end point or angle in radians     ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_MakeXline "Model" (getpoint) (/ pi 4))                                              ;
; =========================================================================================== ;
(defun cd:ENT_MakeXline (Layout Ps Pe)
  (entmakex
    (list
      (cons 0 "XLINE")
      (cons 100 "AcDbEntity")
      (cons 100 "AcDbXline")
      (cons 10 (trans Ps 1 0))
      (cons 11
            (cond
              ((numberp Pe)
               (trans (polar (trans '(0 0 0) 0 1) Pe 1) 1 0)
              )
              ((listp Pe)
               (trans (polar '(0 0 0) (angle Ps Pe) 1) 1 0 T)
              )
            )
      )
      (cons 410 Layout)
    )
  )
)