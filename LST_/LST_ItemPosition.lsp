; =========================================================================================== ;
; Lista wystapien elementu na liscie / List of occurrences item in the list                   ;
;  Item [INT]  - element / element                                                            ;
;  Lst  [LIST] - lista wejsciowa / input list                                                 ;
; ------------------------------------------------------------------------------------------- ;
; (cd:LST_ItemPosition 1 (list 0 "a" 1 "b" 3 1))                                              ;
; =========================================================================================== ;
(defun cd:LST_ItemPosition (Item Lst / n p res)
  (setq n -1)
  (while
    (and
      (setq p (vl-position Item Lst))
      (setq n   (+ (1+ n) p)
            res (cons n res)
            Lst (cdr (member Item Lst))
      )
    )
  )
  (reverse res)
)