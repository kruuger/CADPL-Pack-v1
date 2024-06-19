; =========================================================================================== ;
; Tworzy obiekt typu CIRCLE / Creates a CIRCLE object                                         ;
;  Space  [VLA-Object]  - kolekcja / collection | Model/Paper + Block Object                  ;
;  Pc     [LIST]  - srodek okregu / center of the circle                                      ;
;  Radius [REAL]  - promien / radius                                                          ;
;  ActUcs [T/nil] - dopasuj do aktywnego ucs / adjust to active ucs                           ;
;                   nil = nie / no                                                            ;
;                   T   = tak / yes                                                           ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddCircle (cd:ACX_ASpace) '(1 5 0) 5 T)                                             ;
; =========================================================================================== ;
(defun cd:ACX_AddCircle (Space Pc Radius ActUcs / obj)
  (setq obj (vla-AddCircle
              Space
              (vlax-3d-point (trans Pc 1 0))
              Radius
            )
  )
  (if (not ActUcs)
    (vla-put-normal obj (vlax-3d-point '(0 0 1)))
  )
  obj
)