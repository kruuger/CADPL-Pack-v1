; =========================================================================================== ;
; Zmiana lancucha tekstowego na liste / Convert string into list elements                     ;
;  Val [STR] - lancuch tekstowy / string                                                      ;
; ------------------------------------------------------------------------------------------- ;
; (cd:CON_Value2List "0 1 2 3 5") --> (0 1 2 3 5)                                             ;
; =========================================================================================== ;
(defun cd:CON_Value2List (Val)
  (read (strcat "(" Val ")"))
)