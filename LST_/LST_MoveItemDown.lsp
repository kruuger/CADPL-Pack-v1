; =========================================================================================== ;
; Przesuwa element o jedna pozycje w dol / Moves item one position down                       ;
;  Pos [INT]  - pozycja elementu / element position                                           ;
;  Lst [LIST] - lista wejsciowa / input list                                                  ;
; ------------------------------------------------------------------------------------------- ;
; (cd:LST_MoveItemDown 3 (list 0 1 2 3 4 5))                                                  ;
; =========================================================================================== ;
(defun cd:LST_MoveItemDown (Pos Lst / n)
  (setq n -1)
  (cond
    ((or
       (< Pos 0)
       (>= Pos (1- (length Lst)))
     )
     Lst
    )
    ((mapcar
       (function
         (lambda (%)
           (setq n (1+ n))
           (cond
             ((= n Pos)
              (nth (1+ Pos) Lst)
             )
             ((= n (1+ Pos))
              (nth Pos Lst)
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