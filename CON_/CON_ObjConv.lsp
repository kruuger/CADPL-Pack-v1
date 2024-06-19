; =========================================================================================== ;
; Konwertuje obiekt / Convert object                                                          ;
;  Obj [ENAME/VLA-Object/STR] - obiekt VLA, entycja lub lancuch tekstowy /                    ;
;                               VLA-Object, entity name or string                             ;
;  Format [nil/1/2/3/4] - format wyjsciowy / output format                                    ;
;                         nil = nazwa entycji / entity name                                   ;
;                         1   = obiekt VLA / VLA-Object                                       ;
;                         2   = uchwyt / handle                                               ;
;                         3   = ObjectID                                                      ;
;                         4   = ObjectIdString                                                ;
; ------------------------------------------------------------------------------------------- ;
; (cd:CON_ObjConv (entsel) 2)                                                                 ;
; =========================================================================================== ;
(defun cd:CON_ObjConv (Obj Format / ty res m %)
  (setq ty (type Obj))
  (if
    (setq res (cond
                ((= ty (quote ENAME)) Obj)
                ((= ty (quote VLA-OBJECT)) (vlax-vla-object->ename Obj))
                ((= ty (quote STR))
                 (if (<= (strlen Obj) 8)
                   (handent Obj)
                   (cd:CON_ObjConv (read Obj) nil)
                 )
                )
                ((= ty (quote INT))
                 (if (> Obj 0)
                   (progn
                     (setq m (if
                               (wcmatch
                                 (strcase (getenv "PROCESSOR_ARCHITECTURE"))
                                 "*64*"
                               )
                               "32"
                               ""
                             )
                     )
                     (vl-catch-all-apply
                       (function
                         (lambda ()
                           (setq % (vlax-invoke-method
                                     (cd:ACX_ADoc)
                                     (strcat "ObjectIDtoObject" m)
                                     Obj
                                   )
                           )
                         )
                       )
                     )
                     (if % (vlax-vla-object->ename %))
                   )
                 )
                )
                (T nil)
              )
    )
    (cond
      ((= 1 Format) (vlax-ename->vla-object res))
      ((= 2 Format) (cdr (assoc 5 (entget res))))
      ((= 3 Format) (vla-get-ObjectID (vlax-ename->vla-object res)))
      ((= 4 Format)
       (vlax-invoke-method
         (vla-get-utility (cd:ACX_ADoc))
         "GetObjectIdString"
         (vlax-ename->vla-object res)
         :vlax-false
       )
      )
      (T res)
    )
  )
)