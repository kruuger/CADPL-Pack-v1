; =========================================================================================== ;
; Zastepuje element na liscie / Replaces the item on the list                                 ;
;  Pos [INT]  - pozycja elementu / element position                                           ;
;  Lst [LIST] - lista wejsciowa / input list                                                  ;
;  New [LIST/INT/REAL/STR/ENAME] - nowy element / new item                                    ;
; ------------------------------------------------------------------------------------------- ;
; (cd:LST_ReplaceItem 3 (list 0 1 2 3 4 5) "c")                                               ;
; =========================================================================================== ;
(defun cd:LST_ReplaceItem (Pos Lst New)
  (mapcar
    (function
      (lambda (%)
        (cond
          ((= -1 (setq Pos (1- Pos)))
           New
          )
          (%)
        )
      )
    )
    Lst
  )
)