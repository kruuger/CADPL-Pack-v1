; =========================================================================================== ;
; Zwraca liste symboli LISP-a / Returns LISPs symbols list                                    ;
; ------------------------------------------------------------------------------------------- ;
; (cd:SYS_GetSymbols "cd:")                                                                   ;
; =========================================================================================== ;
(defun cd:SYS_GetSymbols (Str / res)
  (if
    (setq res (vl-remove-if
                (function
                  (lambda (%)
                    (if (not Str)
                      (/= (strcase (substr % 1 4)) "*CD-")
                      (/= (strcase (substr % 1 (strlen Str))) (strcase Str))
                    )
                  )
                )
                (atoms-family 1)
              )
    )
    (mapcar
      (function
        (lambda (%)
          (cons % (vl-symbol-value (read %)))
        )
      )
      (vl-sort res (quote <))
    )
    nil
  )
)