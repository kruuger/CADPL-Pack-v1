; =========================================================================================== ;
; Tworzy automatyczna nazwe / Creates automatic name                                          ;
;  Tbl  [STR]   - tablica symboli / table symbol                                              ;
;  Pref [STR]   - prefiks / prefix                                                            ;
;  Suff [STR]   - sufiks / suffix                                                             ;
;  Char [STR]   - znak uzupelniajacy / supplementary sign                                     ;
;  Len  [INT]   - calkowita liczba znakow / total number of characters                        ;
; ------------------------------------------------------------------------------------------- ;
; (cd:STR_TableNameAuto "BLOCK" "Front_" "_Tyl" "." 3)                                        ;
; (cd:STR_TableNameAuto "LAYER" "Pre_" nil "0" 5)                                             ;
; =========================================================================================== ;
(defun cd:STR_TableNameAuto (Tbl Pref Suff Char Len / res n)
  (foreach % (list "Pref" "Suff" "Char")
    (set (read %) (if (eval (read %)) (eval (read %)) ""))
  )
  (setq res (strcat Pref (cd:STR_FillChar "1" Char Len nil) Suff)
        n   2
  )
  (while (tblsearch Tbl res)
    (setq res (strcat Pref (cd:STR_FillChar (itoa n) Char Len nil) Suff)
          n   (1+ n)
    )
  )
  res
)