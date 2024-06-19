; =========================================================================================== ;
; Zwraca wartosc danego klucza z listy asocjacyjnej /                                         ;
; Returns the value of a key from assoc list                                                  ;
;  Key  [INT]  - klucz / key                                                                  ;
;  Data [LIST] - lista par kropkowych / list of dotted pairs                                  ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DXF_Massoc 10 (entget (car (entsel))))                                                  ;
; =========================================================================================== ;
(defun cd:DXF_Massoc (Key Data / res tmp)
  (while (setq Data (member (setq tmp (assoc Key Data)) Data))
    (setq res  (cons (cdr tmp) res)
          Data (cdr Data)
    )
  )
  (reverse res)
)