; =========================================================================================== ;
; Lista bitow liczby calkowitej / List of bits integer                                        ;
;  Number [INT] - liczba calkowita / integer number                                           ;
; ------------------------------------------------------------------------------------------- ;
; (cd:CAL_BitList 127)                                                                        ;
; =========================================================================================== ;
(defun cd:CAL_BitList (Number / n res)
  (setq n 1)
  (while (>= Number n)
    (and
      (= (logand Number n) n)
      (setq res (cons n res))
    )
    (setq n (lsh n 1))
  )
  (if res
    (reverse res)
    (list Number)
  )
)