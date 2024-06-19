; =========================================================================================== ;
; Tworzy obiekt typu ARC / Creates a ARC object                                               ;
;  Space  [VLA-Object] - kolekcja / collection | Model/Paper + Block Object                   ;
;  Pc     [LIST]  - srodek luku / center of the arc                                           ;
;  Radius [REAL]  - promien / radius                                                          ;
;  As     [REAL]  - kat poczatkowy w radianach / start angle in radians                       ;
;  Ae     [REAL]  - kat koncowy w radianach / end angle in radians                            ;
;  ActUcs [T/nil] - dopasuj do aktywnego ucs / adjust to active ucs                           ;
;                   nil = nie / no                                                            ;
;                   T   = tak / yes                                                           ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddArc (cd:ACX_ASpace) '(1 5 0) 5 0 pi T)                                           ;
; =========================================================================================== ;
(defun cd:ACX_AddArc (Space Pc Radius As Ae ActUcs / zdir xang obj)
  (setq zdir (trans '(0 0 1) 1 0 T)
        xang (angle '(0 0 0) (trans (getvar "UCSXDIR") 0 zdir))
  )
  (setq obj (vla-AddArc Space
                        (vlax-3d-point (trans Pc 1 0))
                        Radius
                        (+ As xang)
                        (+ Ae xang)
            )
  )
  (if (not ActUcs)
    (vla-put-normal obj (vlax-3d-point '(0 0 1)))
  )
  obj
)