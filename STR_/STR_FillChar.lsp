; =========================================================================================== ;
; Uzupelnia lancuch tekstowy znakami / Replaces the item on the list                          ;
;  Str  [STR]   - lancuch tekstowy / string                                                   ;
;  Char [STR]   - znak / character                                                            ;
;  Pos  [INT]   - calkowita liczba znakow / total number of characters                        ;
;  Dir  [T/nil] - kierunek uzupelniania / complement direction                                ;
;                 nil = w lewo / left                                                         ;
;                 T   = w prawo / right                                                       ;
; ------------------------------------------------------------------------------------------- ;
; (cd:STR_FillChar "12" "0" 5 nil)                                                            ;
; =========================================================================================== ;
(defun cd:STR_FillChar (Str Char Pos Dir / res)
  (setq res "")
  (repeat (- Pos (strlen Str))
    (setq res (strcat res Char))
  )
  (if Dir
    (strcat str res)
    (strcat res str)
  )
)