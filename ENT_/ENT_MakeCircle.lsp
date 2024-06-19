; =========================================================================================== ;
; Tworzy obiekt typu CIRCLE / Creates a CIRCLE object                                         ;
;  Layout [STR]   - nazwa arkusza / layout tab name                                           ;
;  Pc     [LIST]  - srodek okregu / center of the circle                                      ;
;  Radius [REAL]  - promien / radius                                                          ;
;  ActUcs [T/nil] - dopasuj do aktywnego ucs / adjust to active ucs                           ;
;                   nil = nie / no                                                            ;
;                   T   = tak / yes                                                           ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_MakeCircle "Model" '(1 5 0) 5 T)                                                    ;
; =========================================================================================== ;
(defun cd:ENT_MakeCircle (Layout Pc Rad ActUcs / zdir)
  (setq zdir (trans (list 0 0 1) 1 0 T))
  (entmakex
    (list
      (cons 0 "CIRCLE")
      (cons 10 (trans Pc 1 (if ActUcs zdir 0)))
      (cons 40 Rad)
      (if ActUcs
        (cons 210 zdir)
        (cons 210 (list 0 0 1))
      )
      (cons 410 Layout)
    )
  )
)