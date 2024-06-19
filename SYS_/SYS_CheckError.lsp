; =========================================================================================== ;
; Sprawdza poprawnosc dzialania funkcji / Checks proper operation of the function             ;
;  Lst [LIST] - sprawdzana funkcja z argumentami / tested the function with arguments         ;
; ------------------------------------------------------------------------------------------- ;
; (cd:SYS_CheckError (list cd:CAL_BitList "199"))                                             ;
; =========================================================================================== ;
(defun cd:SYS_CheckError (Lst / res)
  (if
    (/=
      (type
        (setq res (vl-catch-all-apply
                    (quote (car Lst))
                    (cdr Lst)
                  )
        )
      )
      (quote VL-CATCH-ALL-APPLY-ERROR)
    )
    res
  )
)