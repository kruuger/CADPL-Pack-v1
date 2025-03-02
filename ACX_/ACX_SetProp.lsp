; =========================================================================================== ;
; Zmienia cechy obiektu VLA / Sets the property of VLA-Object                                 ;
;  Obj [ENAME/VLA-Object] - entycja lub obiekt VLA / entity name or VLA-Object                ;
;  Lst [LIST] - lista cech par kropkowych / list of dotted pairs properties                   ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_SetProp  (entlast) '(("LineType" . "BLA")("Color" . 1)("Layer" . "0")))             ;
; =========================================================================================== ;
(defun cd:ACX_SetProp (Obj Lst)
  (if (= (type Obj) (quote ENAME))
    (setq Obj (vlax-ename->vla-object Obj))
  )
  (if (vlax-write-enabled-p Obj)
    (mapcar
      (function
        (lambda (% / %1)
          (cons
            (car %)
            (if (vlax-property-available-p Obj (car %) T)
              (if
                (setq %1 (vl-catch-all-apply
                           (quote vlax-put-property)
                           (list Obj
                                 (car %)
                                 (if (vl-symbolp (cdr %))
                                   (eval (cdr %))
                                   (cdr %)
                                 )
                           )
                         )
                )
                %1
                :vlax-true
              )
              :vlax-null
            )
          )
        )
      )
      Lst
    )
  )
)