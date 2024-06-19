; =========================================================================================== ;
; Tworzy obiekt typu LWPOLYLINE / Creates a LWPOLYLINE object                                 ;
;  Space  [VLA-Object] - kolekcja / collection | Model/Paper + Block Object                   ;
;  Pts    [LIST]  - lista wierzcholkow polilinii / list of polyline vertex                    ;
;  Closed [T/nil] - nil = otwarta / open                                                      ;
;                   T   = zamknieta / closed                                                  ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddLWPolyline (cd:ACX_ASpace) (list '(5 5) '(15 5) '(15 10) '(10 10)) nil)          ;
; =========================================================================================== ;
(defun cd:ACX_AddLWPolyline (Space Pts Closed / obj)
  (setq Pts (apply
              (quote append)
              (mapcar
                (function
                  (lambda (%)
                    (list (car %) (cadr %))
                  )
                )
                (mapcar
                  (function
                    (lambda (%)
                      (trans % 1 (trans '(0 0 1) 1 0 T))
                    )
                  )
                  Pts
                )
              )
            )
  )
  (setq obj (vla-AddLightweightPolyline Space
                                        (vlax-make-variant
                                          (vlax-safearray-fill
                                            (vlax-make-safearray vlax-vbdouble
                                                                 (cons 0
                                                                       (1- (length Pts))
                                                                 )
                                            )
                                            Pts
                                          )
                                        )
            )
  )
  (if Closed (vla-put-closed obj Closed))
  obj
)