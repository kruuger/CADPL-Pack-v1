; =========================================================================================== ;
; Przesuwa element na pozycje 0 / Moves item to the 0th position                              ;
;  Pos [INT]  - pozycja elementu / element position                                           ;
;  Lst [LIST] - lista wejsciowa / input list                                                  ;
; ------------------------------------------------------------------------------------------- ;
; (cd:LST_MoveItemToTop 3 (list 0 1 2 3 4 5))                                                 ;
; =========================================================================================== ;
(defun cd:LST_MoveItemToTop (Pos Lst)
  (cond
    ((or
       (<= Pos 0)
       (>= Pos (length Lst))
     )
     Lst
    )
    ((append
       (list (nth Pos Lst))
       (cd:LST_RemoveItem Pos Lst)
     )
    )
  )
)