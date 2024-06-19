; =========================================================================================== ;
; Tworzy obiekt typu ARC / Creates a ARC object                                               ;
;  Layout [STR]   - nazwa arkusza / layout tab name                                           ;
;  Pc     [LIST]  - srodek luku / center of the arc                                           ;
;  Radius [REAL]  - promien / radius                                                          ;
;  As     [REAL]  - kat poczatkowy w radianach / start angle in radians                       ;
;  Ae     [REAL]  - kat koncowy w radianach / end angle in radians                            ;
;  ActUcs [T/nil] - dopasuj do aktywnego ucs / adjust to active ucs                           ;
;                   nil = nie / no                                                            ;
;                   T   = tak / yes                                                           ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_MakeArc "Model" '(1 5 0) 5 0 pi T)                                                  ;
; =========================================================================================== ;
(defun cd:ENT_MakeArc (Layout Pc Radius As Ae ActUcs / zdir xang)
  (setq zdir (trans (list 0 0 1) 1 0 T)
        xang (angle (list 0 0 0) (trans (getvar "UCSXDIR") 0 zdir))
  )
  (entmakex
    (list
      (cons 0 "ARC")
      (cons 10 (trans Pc 1 (if ActUcs zdir 0)))
      (cons 40 Radius)
      (cons 50 (+ As xang))
      (cons 51 (+ Ae xang))
      (if ActUcs
        (cons 210 zdir)
        (cons 210 (list 0 0 1))
      )
      (cons 410 Layout)
    )
  )
)