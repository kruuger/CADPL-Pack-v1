; =========================================================================================== ;
; Zmiana listy na lancuch tekstowy / Convert list onto text string                            ;
;  LST [LIST] - lista wejsciowa / input list                                                  ;
; ------------------------------------------------------------------------------------------- ;
; (cd:CON_List2Value (list 0 1 2 3 5)) --> "0 1 2 3 5"                                        ;
; =========================================================================================== ;
(defun cd:CON_List2Value (Lst)
  (vl-string-trim "()" (vl-princ-to-string Lst))
)