; =========================================================================================== ;
; Przesuwa element o jedna pozycje w gore / Moves item one position up                        ;
;  Pos [INT]  - pozycja elementu / element position                                           ;
;  Lst [LIST] - lista wejsciowa / input list                                                  ;
; ------------------------------------------------------------------------------------------- ;
; (cd:LST_MoveItemUp 3 (list 0 1 2 3 4 5))                                                    ;
; =========================================================================================== ;
(defun cd:LST_MoveItemUp (Pos Lst / n)
  (setq n -1)
  (cond
    ((or
       (zerop Pos)
       (>= Pos (length Lst))
     )
     Lst
    )
    ((mapcar
       (function
         (lambda (%)
           (setq n (1+ n))
           (cond
             ((= n (1- Pos))
              (nth Pos Lst)
             )
             ((= n Pos)
              (nth (1- Pos) Lst)
             )
             (%)
           )
         )
       )
       Lst
     )
    )
  )
)