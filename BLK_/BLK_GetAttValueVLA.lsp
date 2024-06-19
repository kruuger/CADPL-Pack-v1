; =========================================================================================== ;
; Pobiera wartosc atrybutu / Gets the attribute value                                         ;
;  Obj [ENAME/VLA-Object] - entycja lub obiekt VLA / entity name or VLA-Object                ;
;  Tag [STR] - etykieta atrybutu / attribute tag                                              ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_GetAttValueVLA (car (entsel)) "VIEW_NUMBER")                                        ;
; =========================================================================================== ;
(defun cd:BLK_GetAttValueVLA (Obj Tag)
  (if (= (type Obj) (quote ENAME))
    (setq Obj (vlax-ename->vla-object Obj))
  )
  (vl-some
    (function
      (lambda (%)
        (if (eq (strcase tag) (strcase (vla-get-TagString %)))
          (vla-get-TextString %)
        )
      )
    )
    (vlax-invoke Obj (quote GetAttributes))
  )
)