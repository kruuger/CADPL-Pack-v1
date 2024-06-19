; =========================================================================================== ;
; Pobiera wartosci wszystkich atrybutow / Gets the values of all attributes                   ;
;  Obj [VLA-Object] - obiekt VLA / VLA-Object                                                 ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_GetAttsVLA (vlax-ename->vla-object (car (entsel))))                                 ;
; =========================================================================================== ;
(defun cd:BLK_GetAttsVLA (Obj)
  (mapcar
    (function
      (lambda (%)
        (cons
          (vla-get-TagString %)
          (vla-get-TextString %)
        )
      )
    )
    (vlax-invoke Obj (quote GetAttributes))
  )
)