; =========================================================================================== ;
; Zwraca liste atrybutow wstawionego bloku / Returns a list of attributes of inserted block   ;
;  Ename [ENAME] - nazwa entycji / entity name                                                ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_GetAttEntity (car (entsel)))                                                        ;
; =========================================================================================== ;
(defun cd:BLK_GetAttEntity (Ename / dt ats res)
  (if
    (and
      Ename
      (= "INSERT" (cdr (assoc 0 (setq dt (entget Ename)))))
    )
    (if
      (and
        (setq ats (assoc 66 dt))
        (not (zerop (cdr ats)))
      )
      (reverse
        (while
          (/= "SEQEND"
              (cdr (assoc 0 (entget (setq Ename (entnext Ename)))))
          )
          (setq res (cons Ename res))
        )
      )
    )
  )
)