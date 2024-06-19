; =========================================================================================== ;
; Zapisuje plik tekstowy / Writes the text file                                               ;
;  Name [STR]   - nazwa pliku ze sciezka / file name with path                                ;
;  Lst  [LIST]  - lista do zapisu / list to save                                              ;
;  Mode [T/nil] - tryb zapisu / save mode                                                     ;
;                 nil - nadpisywanie pliku / overwrite the file                               ;
;                 T   - dopisywanie do pliku / append to the file                             ;
; ------------------------------------------------------------------------------------------- ;
; (cd:SYS_WriteFile "d:\\Plik.txt" (list "linia 1" "linia 2" "linia 3") nil)                  ;
; =========================================================================================== ;
(defun cd:SYS_WriteFile (Name Lst Mode / fd)
  (if (setq fd (open Name (if Mode "a" "w")))
    (progn
      (foreach % Lst
        (write-line % fd)
      )
      (not (close fd))
    )
  )
)