; =========================================================================================== ;
; Tworzy obiekt typu LWPOLYLINE / Creates a LWPOLYLINE object                                 ;
;  Layout [STR]   - nazwa arkusza / layout tab name                                           ;
;  Pts    [LIST]  - lista wierzcholkow polilinii / list of polyline vertex                    ;
;  Closed [T/nil] - nil = otwarta / open                                                      ;
;                   T   = zamknieta / closed                                                  ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_MakeLWPolyline "Model" (list '(5 5) '(15 5) '(15 10) '(10 10)) nil)                 ;
; =========================================================================================== ;
(defun cd:ENT_MakeLWPolyline (Layout Pts Closed / zdir)
  (setq zdir (trans '(0 0 1) 1 0 T))
  (entmakex
    (append
      (list
        (cons 0 "LWPOLYLINE")
        (cons 100 "AcDbEntity")
        (cons 100 "AcDbPolyline")
        (cons 38 (caddr (trans (car Pts) 1 zdir)))
        (cons 90 (length Pts))
        (cons 70 (if Closed 1 0))
        (cons 210 zdir)
        (cons 410 Layout)
      )
      (mapcar
        (function
          (lambda (%)
            (cons 10 (trans % 1 zdir))
          )
        )
        Pts
      )
    )
  )
)