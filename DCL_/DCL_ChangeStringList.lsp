; =========================================================================================== ;
; Obsluga listy lancuchow tekstowych / Handling of the list of strings                        ;
;  Key   [STR]  - nazwa wycinka / tile name                                                   ;
;  Lst   [LIST] - lista / list                                                                ;
;  Pos   [INT]  - aktualna pozycja na liscie / current position in the list                   ;
;  Old   [STR]  - poprzednia pozycja na liscie / old item on the list                         ;
;  Label [STR]  - etykieta dla pozycji "Nowa..." / label for "New..." position                ;
;  Func  [SUBR] - funkcja do obslugi okienka edit_box / function to operate edit_box dialog   ;
; =========================================================================================== ;
(defun cd:DCL_ChangeStringList (Key Lst Pos Old Label Func / tmp len res)
  (setq tmp Old
        len (length Lst)
  )
  (cond
    ((< Pos len)
     (setq res (nth Pos Lst))
    )
    ((= Pos len)
     (cond
       ((setq res (eval Func)))
       ((setq res tmp))
     )
    )
    (T (setq res tmp))
  )
  (if res (cd:DCL_FillStringList Key Lst res Label))
  res
)