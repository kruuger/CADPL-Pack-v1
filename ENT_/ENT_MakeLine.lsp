; =========================================================================================== ;
; Tworzy obiekt typu LINE / Creates a LINE object                                             ;
;  Layout [STR]   - nazwa arkusza / layout tab name                                           ;
;  Ps     [LIST]  - punkt poczatkowy / start point                                            ;
;  Pe     [LIST]  - punkt koncowy / end point                                                 ;
;  ActUcs [T/nil] - dopasuj do aktywnego ucs / adjust to active ucs                           ;
;                   nil = nie / no                                                            ;
;                   T   = tak / yes                                                           ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_MakeLine "Model" '(20 10 0) '(100 50 0) T)                                          ;
; =========================================================================================== ;
(defun cd:ENT_MakeLine (Layout Ps Pe ActUcs / zdir)
  (setq zdir (trans (list 0 0 1) 1 0 T))
  (entmakex
    (list
      (cons 0 "LINE")
      (cons 10 (trans Ps 1 0))
      (cons 11 (trans Pe 1 0))
      (if ActUcs
        (cons 210 zdir)
        (cons 210 (list 0 0 1))
      )
      (cons 410 Layout)
    )
  )
)