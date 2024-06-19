; =========================================================================================== ;
; Czyta plik tekstowy / Read a text file                                                      ;
; Line [INT/nil] - INT = numer linii pliku / file line number                                 ;
;                  nil = caly plik / all lines of file                                        ;
; File [STR] - nazwa pliku (krotka lub ze sciezka) / short or full path file name             ;
; ------------------------------------------------------------------------------------------- ;
; Zwraca / Return:                                                                            ;
;   nil = gdy Line = INT wieksze niz ilosc linii w pliku lub plik jest pusty /                ;
;         when Line = INT is greater then number of lines in file or file is empty            ;
;     0 = brak dostepu do pliku / no access to file                                           ;
;    -1 = nie znaleziono pliku / file not found                                               ;
;   STR = gdy Line = INT / when Line = INT                                                    ;
;  LIST = gdy Line = nil / when Line = nil                                                    ;
; ------------------------------------------------------------------------------------------- ;
; (cd:SYS_ReadFile nil "data.ini"), (cd:SYS_ReadFile 10 "acad.lin")                           ;
; =========================================================================================== ;
(defun cd:SYS_ReadFile (Line File / fn fd l res)
  (if (setq fn (findfile File))
    (if (setq fd (open fn "r"))
      (progn
        (if Line
          (progn
            (repeat Line (read-line fd))
            (setq res (read-line fd))
          )
          (progn
            (setq l T)
            (while l
              (setq res (cons
                          (setq l (read-line fd))
                          res
                        )
              )
            )
            (setq res (reverse (cdr res)))
          )
        )
        (close fd)
      )
      (setq res 0)
    )
    (setq res -1)
  )
  res
)