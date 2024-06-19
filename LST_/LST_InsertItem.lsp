; =========================================================================================== ;
; Wstawia nowy element na liste / Inserts a new item in the list                              ;
;  Pos [INT]  - pozycja elementu / element position                                           ;
;  Lst [LIST] - lista wejsciowa / input list                                                  ;
;  New [LIST/INT/REAL/STR/ENAME] - nowy element / new item                                    ;
; ------------------------------------------------------------------------------------------- ;
; (cd:LST_InsertItem 3 (list 0 1 2 4 5) 3)                                                    ;
; =========================================================================================== ;
(defun cd:LST_InsertItem (Pos Lst New / res)
  (if (< -1 Pos (1+ (length Lst)))
    (progn
      (repeat Pos
        (setq res (cons (car Lst) res)
              Lst (cdr Lst)
        )
      )
      (append (reverse res) (list New) Lst)
    )
    Lst
  )
)