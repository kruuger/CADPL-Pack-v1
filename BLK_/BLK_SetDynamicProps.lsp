; =========================================================================================== ;
; Zmienia wlasciwosci bloku dynamicznego / Sets the dynamic block properties                  ;
;  Obj  [ENAME/VLA-Object] - entycja lub obiekt VLA / entity name or VLA-Object               ;
;  Prop [STR]              - wlasciwosc / property                                            ;
;  Val  [REAL/INT/STR]     - nowa wartosc / new value                                         ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_SetDynamicProps (car (entsel)) "Height" 50)                                         ;
; =========================================================================================== ;
(defun cd:BLK_SetDynamicProps (Obj Prop Val)
  (if (= (type Obj) (quote ENAME))
    (setq Obj (vlax-ename->vla-object Obj))
  )
  (vl-some
    (function
      (lambda (%)
        (if (eq (strcase Prop) (strcase (vla-get-PropertyName %)))
          (if
            (not
              (vl-catch-all-error-p
                (vl-catch-all-apply
                  (quote vla-put-value)
                  (list
                    %
                    (vlax-make-variant
                      Val
                      (vlax-variant-type (vla-get-value %))
                    )
                  )
                )
              )
            )
            Val
          )
        )
      )
    )
    (vlax-invoke Obj (quote GetDynamicBlockProperties))
  )
)