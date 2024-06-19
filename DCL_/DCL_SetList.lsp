; =========================================================================================== ;
; Wypelnia wycinki "list_box" i "popup_list" / Fills "list_box" and "popup_list" tiles        ;
;  Key [STR]              - nazwa wycinka / tile name                                         ;
;  Lst [LIST]             - lista do wypelnienia / list to fill                               ;
;  Pos [INT/REAL/STR/nil] - aktualna pozycja na liscie / current position on the list         ;
; =========================================================================================== ;
(defun cd:DCL_SetList (Key Lst Pos)
  (start_list Key)
  (mapcar (quote add_list) Lst)
  (end_list)
  (set_tile Key
            (cond
              ((numberp Pos) (itoa (fix Pos)))
              ((= (type Pos) (quote STR)) Pos)
              (T (itoa 0))
            )
  )
)