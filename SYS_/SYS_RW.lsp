; =========================================================================================== ;
; Odczyt/Zapis danych w rejestrze / Reads/Writes data to the registry                         ;
;  Key  [STR]     - klucz rejestru / registry key                                             ;
;  Name [STR]     - wartosc wpisu w rejestrze / value of a registry entry                     ;
;  Data [STR/nil] - nil = odczyt danych / read data                                           ;
;                   STR = dane do zapisu / data to write                                      ;
; =========================================================================================== ;
; (cd:SYS_RW "CADPL\\Tools\\MakeBlock" "Version" "1.0")                                       ;
; =========================================================================================== ;
(defun cd:SYS_RW (Key Name Data / loc)
  (setq loc (strcat "HKEY_CURRENT_USER\\Software\\" Key))
  (cond
    ((and Name Data)
     (vl-registry-write loc Name Data)
    )
    (Data
     (vl-registry-write loc nil Data)
    )
    (T
     (vl-registry-read loc Name)
    )
  )
)