; =========================================================================================== ;
; Tworzy ciag arytmetyczny / Creates arithmetic sequence                                      ;
;  St [REAL/INT] - liczba poczatkowa / initial number                                         ;
;  Le [REAL/INT] - dlugosc ciagu / sequence length                                            ;
;  Sp [REAL/INT] - roznica ciagu  / sequence difference                                       ;
; ------------------------------------------------------------------------------------------- ;
; (cd:CAL_Sequence 1.50 10 0.5)                                                               ;
; =========================================================================================== ;
(defun cd:CAL_Sequence (St Le Sp / res)
  (if (vl-every (quote numberp) (list St Le Sp))
    (progn
      (setq res (list St))
      (repeat (fix (1- Le))
        (setq res (cons
                    (setq St (+ St Sp))
                    res
                  )
        )
      )
      (reverse res)
    )
  )
)