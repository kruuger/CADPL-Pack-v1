; =========================================================================================== ;
; Tworzy obiekt typu LINE / Creates a LINE object                                             ;
;  Space  [VLA-Object] - kolekcja / collection | Model/Paper + Block Object                   ;
;  Ps     [LIST] - punkt poczatkowy / start point                                             ;
;  Pe     [LIST] - punkt koncowy / end point                                                  ;
;  ActUcs [T/nil] - dopasuj do aktywnego ucs / adjust to active ucs                           ;
;                   nil = nie / no                                                            ;
;                   T   = tak / yes                                                           ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddLine (cd:ACX_ASpace) '(20 10 0) '(100 50 0) T)                                   ;
; =========================================================================================== ;
(defun cd:ACX_AddLine (Space Ps Pe ActUcs / obj)
  (setq obj (vla-AddLine Space
                         (vlax-3d-point (trans Ps 1 0))
                         (vlax-3d-point (trans Pe 1 0))
            )
  )
  (if (not ActUcs)
    (vla-put-normal obj (vlax-3d-point '(0 0 1)))
  )
  obj
)