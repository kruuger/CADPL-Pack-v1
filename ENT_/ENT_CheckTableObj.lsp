; =========================================================================================== ;
; Sprawdza poprawnosc nazwanego obiektu / Checks the correctness of the named object          ;
;  Table [STR] - nazwa obiektu / object name                                                  ;
;  Name  [STR] - nazwa do sprawdzenia / name to check                                         ;
; ------------------------------------------------------------------------------------------- ;
; Zwraca / Return:                                                                            ;
;   0 = obiekt nie istnieje / object does not exist                                           ;
;  -1 = zla nazwa / bad name                                                                  ;
;   1 = obiekt istnieje / object exists                                                       ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_CheckTableObj "LAYER" "0"), (cd:ENT_CheckTableObj "BLOCK" "nazwa")                  ;
; =========================================================================================== ;
(defun cd:ENT_CheckTableObj (Table Name)
  (if (not (tblobjname Table Name))
    (if (snvalid Name 0)
      0
      -1
    )
    1
  )
)