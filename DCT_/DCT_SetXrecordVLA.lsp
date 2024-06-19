; =========================================================================================== ;
; Zmienia Xrecord / Change Xrecord                                                            ;
;  Ename [ENAME] - nazwa entycji / entity name                                                ;
;  Data  [LIST]  - lista par kropkowych / list of dotted pairs                                ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCT_SetXrecordVLA                                                                       ;
;   (cdar (cd:DCT_GetDictList (cd:DCT_GetDict (namedobjdict) "NAZWA") T))                     ;
;   (list (cons 1 "NEW123") (cons 341 (car (entsel)))))                                       ;
; =========================================================================================== ;
(defun cd:DCT_SetXrecordVLA (Ename Data / n)
  (setq n (1- (length Data)))
  (vla-SetXRecordData
    (vlax-ename->vla-object Ename)
    (vlax-make-variant
      (vlax-safearray-fill
        (vlax-make-safearray
          vlax-vbInteger
          (cons 0 n)
        )
        (mapcar (quote car) Data)
      )
    )
    (vlax-make-variant
      (vlax-safearray-fill
        (vlax-make-safearray
          vlax-vbVariant
          (cons 0 n)
        )
        (mapcar
          (function
            (lambda (% / %1)
              (setq %1 (type %))
              (cond
                ((= %1 (quote ENAME)) (vlax-ename->vla-object %))
                ((= %1 (quote LIST)) (vlax-3d-point %))
                (T %)
              )
            )
          )
          (mapcar (quote cdr) Data)
        )
      )
    )
  )
  (cd:DCT_GetXRecord Ename)
)