; =========================================================================================== ;
; Tworzy obiekt typu ELLIPSE / Creates a ELLIPSE object                                       ;
;  Layout [STR]   - nazwa arkusza / layout tab name                                           ;
;  Pc     [LIST]  - srodek elipsy / center of the ellipse                                     ;
;  Width  [REAL]  - szerokosc / width                                                         ;
;  Height [REAL]  - wysokosc / height                                                         ;
;  RotAng [REAL]  - kat obrotu / rotation angle                                               ;
;  ActUcs [T/nil] - dopasuj do aktywnego ucs / adjust to active ucs                           ;
;                   nil = nie / no                                                            ;
;                   T   = tak / yes                                                           ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_MakeEllipse "Model" '(1 5 0) 10.0 5.0 (* pi 0.25) T)                                ;
; =========================================================================================== ;
(defun cd:ENT_MakeEllipse (Layout Pc Width Height RotAng ActUcs / zdir xang)
  (setq zdir (trans (list 0 0 1) 1 0 T)
        xang (angle (list 0 0 0) (trans (getvar "UCSXDIR") 0 zdir))
  )
  (entmakex
    (list
      (cons 0 "ELLIPSE")
      (cons 100 "AcDbEntity")
      (cons 100 "AcDbEllipse")
      (cons 10 (trans Pc 1 0))
      (if ActUcs
        (cons 11 (trans (polar (trans (list 0 0 0) 0 1) RotAng (/ Width 2.0)) 1 0))
        (cons 11 (polar (list 0 0 0) (+ RotAng xang) (/ Width 2.0)))
      )
      (cons 40 (/ (float Height) (float Width)))
      (if ActUcs
        (cons 210 zdir)
        (cons 210 (list 0 0 1))
      )
      (cons 410 Layout)
    )
  )
)