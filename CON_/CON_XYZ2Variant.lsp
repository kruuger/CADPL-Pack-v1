; =========================================================================================== ;
; Zamienia liste liczb na 3DPoint (variant) / Converts a list of numbers to 3DPoint (variant) ;
;  Lst [LIST] - 2 lub 3 elementowa lista liczb / 2 or 3 element list of numbers               ;
; ------------------------------------------------------------------------------------------- ;
; (cd:CON_XYZ2Variant (list 10 2)), (cd:CON_XYZ2Variant (list 4 4 4))                         ;
; =========================================================================================== ;
(defun cd:CON_XYZ2Variant (Lst)
  (cond
    ((listp Lst)
     (if
       (and
         (member (length Lst) (list 2 3))
         (apply (quote and)
                (mapcar
                  (function
                    (lambda (%)
                      (numberp %)
                    )
                  )
                  Lst
                )
         )
       )
       (vlax-3d-Point Lst)
     )
    )
    ((and
       (= (type Lst) (quote VARIANT))
       (= (vlax-variant-type Lst) 8197)
     )
     Lst
    )
    (T nil)
  )
)