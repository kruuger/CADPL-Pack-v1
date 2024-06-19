; =========================================================================================== ;
; Usuwa element z listy / Removes the item from the list                                      ;
;  Pos [INT]  - pozycja elementu / element position                                           ;
;  Lst [LIST] - lista wejsciowa / input list                                                  ;
; ------------------------------------------------------------------------------------------- ;
; (cd:LST_RemoveItem 3 (list 0 1 2 3 4 5))                                                    ;
; =========================================================================================== ;
(defun cd:LST_RemoveItem (Pos Lst)
  (vl-remove-if
    (function
      (lambda (%)
        (= -1 (setq Pos (1- Pos)))
      )
    )
    Lst
  )
)