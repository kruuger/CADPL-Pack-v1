; =========================================================================================== ;
; Przesuwa element na ostatnia pozycje / Moves item to the last position                      ;
;  Pos [INT]  - pozycja elementu / element position                                           ;
;  Lst [LIST] - lista wejsciowa / input list                                                  ;
; ------------------------------------------------------------------------------------------- ;
; (cd:LST_MoveItemToBottom 3 (list 0 1 2 3 4 5))                                              ;
; =========================================================================================== ;
(defun cd:LST_MoveItemToBottom (Pos Lst)
  (cond
    ((or
       (< Pos 0)
       (>= Pos (1- (length Lst)))
     )
     Lst
    )
    ((append
       (cd:LST_RemoveItem Pos Lst)
       (list (nth Pos Lst))
     )
    )
  )
)