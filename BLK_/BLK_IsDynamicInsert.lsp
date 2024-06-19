; =========================================================================================== ;
; Sprawdza czy blok jest blokiem dynamicznym / Checks if the block is a dynamic block         ;
;  Obj [ENAME/VLA-Object] - entycja lub obiekt VLA / entity name or VLA-Object                ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_IsDynamicInsert (car (entsel)))                                                     ;
; =========================================================================================== ;
(defun cd:BLK_IsDynamicInsert (Obj)
  (if (= (type Obj) (quote ENAME))
    (setq Obj (vlax-ename->vla-object Obj))
  )
  (= :vlax-true (vla-get-IsDynamicBlock Obj))
)