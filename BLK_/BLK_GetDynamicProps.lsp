; =========================================================================================== ;
; Pobiera wlasciwosci bloku dynamicznego / Gets the dynamic block properties                  ;
;  Obj    [ENAME/VLA-Object] - entycja lub obiekt VLA / entity name or VLA-Object             ;
;  Origin [T/nil] - pokaz wlasciwosc ORIGIN / show the ORIGIN property                        ;
;                   nil = nie / no                                                            ;
;                   T = tak / yes                                                             ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_GetDynamicProps (car (entsel)) T)                                                   ;
; =========================================================================================== ;
(defun cd:BLK_GetDynamicProps (Obj Origin / _Sub pn res)
  (defun _Sub ()
    (setq res (cons
                (cons
                  pn
                  (vlax-get % (quote Value))
                )
                res
              )
    )
  )
  (if (= (type Obj) (quote ENAME))
    (setq Obj (vlax-ename->vla-object Obj))
  )
  (foreach % (vlax-invoke Obj (quote GetDynamicBlockProperties))
    (setq pn (vla-get-PropertyName %))
    (if Origin
      (_Sub)
      (if (/= (strcase pn) "ORIGIN") (_Sub))
    )
  )
  res
)