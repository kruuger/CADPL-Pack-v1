; =========================================================================================== ;
; Zmienia wartosc atrybutu / Sets the attribute value                                         ;
;  Obj [ENAME/VLA-Object] - entycja lub obiekt VLA / entity name or VLA-Object                ;
;  Tag   [STR] - etykieta atrybutu / attribute tag                                            ;
;  Value [STR] - wartosc atrybuty / attribute value                                           ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_SetAttValueVLA (car (entsel)) "VIEW_NUMBER" "12")                                   ;
; =========================================================================================== ;
(defun cd:BLK_SetAttValueVLA (Obj Tag Value)
  (if (= (type Obj) (quote ENAME))
    (setq Obj (vlax-ename->vla-object Obj))
  )
  (vl-some
    (function
      (lambda (%)
        (if (eq (strcase tag) (strcase (vla-get-TagString %)))
          (progn
            (vla-put-TextString % Value)
            Value
          )
        )
      )
    )
    (vlax-invoke Obj (quote GetAttributes))
  )
)