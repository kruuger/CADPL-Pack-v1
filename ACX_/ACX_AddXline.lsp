; =========================================================================================== ;
; Tworzy obiekt typu XLINE / Creates a XLINE object                                           ;
;  Space  [VLA-Object] - kolekcja / collection | Model/Paper + Block Object                   ;
;  Ps     [LIST]       - punkt poczatkowy / start point                                       ;
;  Pe     [LIST/REAL]  - punkt koncowy lub kat w radianach / end point or angle in radians    ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddXline (cd:ACX_ASpace) (getpoint) (/ pi 4))                                       ;
; =========================================================================================== ;
(defun cd:ACX_AddXline (Space Ps Pe)
  (vla-AddXline
    Space
    (vlax-3d-point (trans Ps 1 0))
    (vlax-3d-point
      (cond
        ((numberp Pe)
         (trans (polar Ps Pe 1) 1 0)
        )
        ((listp Pe)
         (trans (list (car Pe) (cadr Pe) (caddr Ps)) 1 0)
        )
      )
    )
  )
)