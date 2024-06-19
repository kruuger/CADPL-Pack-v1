; =========================================================================================== ;
; Pobiera/Tworzy ExtensionDictionary obiektu / Gets/Creates an ExtensionDictionary of object  ;
;  Obj  [ENAME/VLA-Object] - entycja lub obiekt VLA / entity name or VLA-Object               ;
;  Flag [T/nil] - T   = tworzy / creates                                                      ;
;                 nil = pobiera jesli istnieje / gets if exist                                ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCT_GetExtDictVLA (car (entsel)) T)                                                     ;
; =========================================================================================== ;
(defun cd:DCT_GetExtDictVLA (Obj Flag / res)
  (if (= (type Obj) (quote ENAME))
    (setq Obj (vlax-ename->vla-object Obj))
  )
  (if
    (setq res (if (= :vlax-true (vla-get-HasExtensionDictionary Obj))
                (vla-GetExtensionDictionary Obj)
                (if Flag (vla-GetExtensionDictionary Obj))
              )
    )
    (vlax-vla-object->ename res)
  )
)