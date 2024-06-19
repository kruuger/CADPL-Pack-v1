; =========================================================================================== ;
; Zamienia elementy miejscami / Reverse the elements in places                                ;
;  Pos1 [INT]  - pozycja 1-go elementu / first element position                               ;
;  Pos2 [INT]  - pozycja 2-go elementu / second element position                              ;
;  Lst  [LIST] - lista wejsciowa / input list                                                 ;
; ------------------------------------------------------------------------------------------- ;
; (cd:LST_ReverseItems 0 5 (list 0 1 2 3 4 5))                                                ;
; =========================================================================================== ;
(defun cd:LST_ReverseItems (Pos1 Pos2 Lst / n)
  (setq n -1)
  (cond
    ((or
       (< Pos1 0)
       (< Pos2 0)
       (>= Pos1 (length Lst))
       (>= Pos2 (length Lst))
     )
     Lst
    )
    ((mapcar
       (function
         (lambda (%)
           (setq n (1+ n))
           (cond
             ((= n Pos1)
              (nth Pos2 Lst)
             )
             ((= n Pos2)
              (nth Pos1 Lst)
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