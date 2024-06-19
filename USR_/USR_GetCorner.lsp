; =========================================================================================== ;
; Pobiera drugi naroznik prostokata / Get second corner of rectangle                          ;
;  Pt   [LIST]  - punkt bazowy / base point                                                   ;
;  Msg  [STR]   - komunikat do wyswietlenia / message to display                              ;
;  Mode [T/nil] - typ zwracanych danych / type of returned data                               ;
;                 nil = drugi naroznik / second corner                                        ;
;                 T   = lista wspolrzednych w kolejnosci: DL DP GP GL                         ;
;                       list of coordinates in order: LL LR UR UL                             ;
; ------------------------------------------------------------------------------------------- ;
; (cd:USR_GetCorner (getpoint) "\nWskaz drugi naroznik: " T)                                  ;
; =========================================================================================== ;
(defun cd:USR_GetCorner (Pt Msg Mode / loop res lst)
  (setq loop T)
  (while loop
    (and
      (setq res (getcorner Pt Msg))
      (not (equal (car Pt) (car res)))
      (not (equal (cadr Pt) (cadr res)))
      (setq loop nil)
    )
  )
  (if Mode
    (progn
      (setq lst (mapcar
                  '(lambda (%1)
                     (mapcar (quote (eval %1)) (list Pt res))
                   )
                  '(car cadr)
                )
      )
      (mapcar
        '(lambda (%1)
           (mapcar
             '(lambda (%2 %3)
                (apply (quote (eval %2)) %3)
              )
             %1
             lst
           )
         )
        '((min min)
          (max min)
          (max max)
          (min max)
         )
      )
    )
    res
  )
)