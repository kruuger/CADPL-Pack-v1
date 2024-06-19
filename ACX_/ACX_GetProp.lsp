; =========================================================================================== ;
; Pobiera cechy obiektu VLA/ENAME / Gets the object VLA-Object/ENAME properties               ;
;  Obj [ENAME/VLA-Object] - entycja lub obiekt VLA / entity name or VLA-Object                ;
;  Lst [LIST] - lista cech / list of properties                                               ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_GetProp (entlast) '("LineType" "Color" "Layer"))                                    ;
; =========================================================================================== ;
(defun cd:ACX_GetProp (Obj Lst)
  (if (= (type Obj) (quote ENAME))
    (setq Obj (vlax-ename->vla-object Obj))
  )
  (mapcar
    (function
      (lambda (% / %1)
        (cons %
              (if (vlax-property-available-p Obj % nil)
                (if
                  (not
                    (setq %1 (cd:SYS_CheckError (list vlax-get-property Obj %)))
                  )
                  :vlax-false
                  %1
                )
                :vlax-null
              )
        )
      )
    )
    Lst
  )
)