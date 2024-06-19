; =========================================================================================== ;
; Okno dialogowe "edit_box" / "edit_box" dialog control                                       ;
;  Data      [LIST]     - argumetny (maks. 7) / arguments (max. 7) | (list a b c d e f g)     ;
;   * STR - dowolny lancuch / any string                                                      ;
;     a = 0                                                                                   ;
;     b - INT  = rodzaje bledow / type of errors                                              ;
;         LIST = rodzaje bledow wraz z komunikatem / type of errors with the messages         ;
;     c - wartosc domyslna / default value                                                    ;
;   * STR - zgodny z tablica/wzorcem / consistent with table/pattern                          ;
;     a = 1                                                                                   ;
;     b - INT  = rodzaje bledow / type of errors                                              ;
;         LIST = rodzaje bledow wraz z komunikatem / type of errors with the messages         ;
;     c - wartosc domyslna / default value                                                    ;
;     d - nazwa tablicy / table name                                                          ;
;     e = wzorzec / pattern                                                                   ;
;     f = lista uzytkownika / user list                                                       ;
;   * INT = 2, REAL = 3                                                                       ;
;     a = 2,3                                                                                 ;
;     b - INT  = rodzaje bledow / type of errors                                              ;
;         LIST = rodzaje bledow wraz z komunikatem / type of errors with the messages         ;
;     c - wartosc domyslna / default value                                                    ;
;     d - wartosc minimalna / minimum value                                                   ;
;     e - wartosc maksymalna / maximum value                                                  ;
;     f - jednostki wyjsciowe / output unit                                                   ;
;         nil = domyslne / default | (getvar "LUNITS")                                        ;
;         1   = naukowe / scientific                                                          ;
;         2   = dziesietne / decimal                                                          ;
;         3   = inzynierskie / engineering                                                    ;
;         4   = architektoniczne / architectural                                              ;
;         5   = ulamkowe / fractional                                                         ;
;     g - INT = liczba miejsc po przecinku / number of decimal places                         ;
;         nil = domyslna / default | (getvar "LUPREC")                                        ;
;  Title     [STR/nil]  - tytul okna / window title                                           ;
;  EditTitle [STR/nil]  - tytul "edit_box" / "edit_box" title                                 ;
;  Width     [INT]      - szerokosc / width                                                   ;
;  BtnsWidth [REAL/INT] - szerokosc przyciskow / buttons width                                ;
;  BtnsLabel [LIST]     - etykiety przyciskow / buttons label                                 ;
;  DPos      [T/nil]    - zapamietanie pozycji okna / save window position                    ;
;  Limit     [INT]      - limit znakow / signs limit                                          ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCL_StdEditBoxDialog (list 0 0 "") "Poziom" "Nowy:" 40 13 (list "&Ok" "&Anuluj") T  5)  ;
; (cd:DCL_StdEditBoxDialog                                                                    ;
;   (list 1                                                                                   ;
;     (list                                                                                   ;
;       (cons 1 "Wprowadz dane")                                                              ;
;       (cons 2 "Niepoprawna warstwa")                                                        ;
;       (cons 4 "Warstwa wystepuje w rysunku")                                                ;
;       (cons 16 "Warstwa nie pasuje do wzorca")                                              ;
;     )                                                                                       ;
;     "" "LAYER" "??-??"                                                                      ;
;   )                                                                                         ;
;   "Warstwa" "Nowa warstwa: (format ??-??)" 40 13 (list "&Ok" "&Anuluj") T 5                 ;
; )                                                                                           ;
; (cd:DCL_StdEditBoxDialog                                                                    ;
;   (list 3                                                                                   ;
;     (list                                                                                   ;
;       (cons 1 "Wprowadz liczbe rzeczywista")                                                ;
;       (cons 2 "Liczba nie moze byc zerem")                                                  ;
;       (cons 8 "Spacje niedozwolone")                                                        ;
;       (cons 16 "To nie jest liczba")                                                        ;
;       (cons 32 "Liczba jest za mala")                                                       ;
;       (cons 64 "Liczba jest za duza")                                                       ;
;     )                                                                                       ;
;     "19" -100 100 2 2                                                                       ;
;   )                                                                                         ;
;   "Poziom" "Wprowadz poziom: (-100 < X < 100)" 40 13 (list "&Ok" "&Anuluj") T nil           ;
; )                                                                                           ;
; =========================================================================================== ;
(defun cd:DCL_StdEditBoxDialog (Data Title EditTitle Width BtnsWidth BtnsLabel DPos
                                Limit / _CheckVal fd tmp dc defval res fl
                               )
  (defun _CheckVal (Code Bit Val / tmp _Logand _IsBlank _IsSpaces _Pattern _UserList
                    _Error _StrUnit _Nth _IsNumb res err
                   )
    (setq tmp Bit)
    (if (not fl) (setq Bit (apply (quote +) (mapcar (quote car) Bit))))
    (defun _Logand (b) (= b (logand Bit b)))
    (defun _IsBlank (s) (= s ""))
    (defun _IsSpaces (s) (not (vl-remove '32 (vl-string->list s))))
    (defun _Pattern (s) (not (wcmatch s (_Nth 4))))
    (defun _UserList (s) (member (strcase Val) (mapcar (quote strcase) (_Nth 5))))
    (defun _Error (b) (if (not fl) (setq err (cdr (assoc b tmp)))))
    (defun _StrUnit (s) (distof s 3))
    (defun _Nth (n / p)
      (if (setq p (vl-catch-all-apply (quote nth) (list n Data)))
        p
        (vl-catch-all-error-p p)
      )
    )
    (defun _IsNumb (s b / r)
      (if (setq r (_StrUnit s))
        (cond
          ((and (= 1 (logand 1 b)) (numberp r))) ; liczba / number
          ((and (= 2 (logand 2 b)) (zerop r))) ; zero   / zero
          ((and (= 4 (logand 4 b)) (minusp r))) ; ujemna / negative
          (T nil)
        )
      )
    )
    (cond
      ((= Code 0) ; dowolny lancuch / any string
       (cond
         ((and (_Logand 1) (_IsBlank Val)) (_Error 1)) ; bez ""            / no ""
         ((and (_Logand 8) (_IsSpaces Val)) (_Error 8)) ; bez samych spacji / no spaces
         (T (setq res Val))
       )
      )
      ((= Code 1) ; lancuch zgodny z nazwa tablicy / string consistent with table name
       (cond
         ((and (_Logand 1) (_IsBlank Val)) (_Error 1)) ; bez ""                  / no ""
         ((and (_Logand 2) (not (snvalid Val))) (_Error 2)) ; bez zlej nazwy snvalid  / no bad name
         ((and (_Logand 4) (tblsearch (_Nth 3) Val)) (_Error 4)) ; bez istniejacych nazw   / no existing name
         ((and (_Logand 8) (_IsSpaces Val)) (_Error 8)) ; bez samych spacji       / no spaces
         ((and (_Logand 16) (_Pattern Val)) (_Error 16)) ; pasujacy do wzorca      / match pattern
         ((and (_Logand 32) (_UserList Val)) (_Error 32)) ; nie wystepuje na liscie / does not appear in the list
         (T (setq res Val))
       )
      )
      ((member Code (list 2 3)) ; INT = 2, REAL = 3
       (cond
         ((and (_Logand 1) (_IsBlank Val)) (_Error 1)) ; bez ""            / no ""
         ((and (_Logand 2) (_IsNumb Val 2)) (_Error 2)) ; bez zera          / no zero
         ((and (_Logand 4) (_IsNumb Val 4)) (_Error 4)) ; bez ujemnych      / no negative
         ((and (_Logand 8) (_IsSpaces Val)) (_Error 8)) ; bez samych spacji / no spaces
         ((and (_Logand 16) (not (_IsNumb Val 1))) (_Error 16)) ; tylko liczby      / only number
         ((and (_Logand 32) (> (_Nth 3) (_StrUnit Val))) (_Error 32)) ; liczba za mala    / number to small
         ((and (_Logand 64) (< (_Nth 4) (_StrUnit Val))) (_Error 64)) ; liczba za duza    / number to big
         (T
          (setq res (if (_IsNumb Val 1)
                      (if (= Code 2)
                        (itoa (fix (_StrUnit Val)))
                        (cd:CON_Real2Str (_StrUnit Val) (_Nth 5) (_Nth 6))
                      )
                      Val
                    )
          )
         )
       )
      )
      (T nil)
    )
    (if (and defval res)
      (set_tile "edit" res)
      (set_tile "edit" Val)
    )
    (if err
      (set_tile "error" err)
      (set_tile "error" "")
    )
    res
  )
  (if (not DPos) (setq *cd-TempDlgPosition* (list -1 -1)))
  (cond
    ((not
       (and
         (setq fd (open
                    (setq tmp (vl-FileName-MkTemp nil nil ".dcl"))
                    "w"
                  )
         )
         (foreach %
           (list
             (strcat
               "but : button { width = "
               (if BtnsWidth (itoa BtnsWidth) "13")
               "; fixed_width = true; }"
               "StdEditBoxDialog : dialog {"
               (if Title (strcat "label = \"" Title "\";") "")
               "  : boxed_column {"
               (if EditTitle (strcat "label = \"" EditTitle "\";") "")
               "    width = "
               (if Width (itoa Width) "20")
               ";"
               "    : edit_box { key = \"edit\";"
               (if Limit (strcat "edit_limit = " (itoa Limit) ";") "")
               "    } spacer; }"
               "  : row { alignment = centered; fixed_width = true;"
               "  : but { key = \""
               (car BtnsLabel)
               "\";"
               "    label = \""
               (car BtnsLabel)
               "\"; is_default = true; }"
               "  : but { key = \""
               (cadr BtnsLabel)
               "\";"
               "    label = \""
               (cadr BtnsLabel)
               "\"; is_cancel = true; }"
               "  } "
               (if (setq fl (= (type (cadr Data)) (quote INT)))
                 ""
                 ": errtile { width = 20; }"
               )
               " }"
             )
           )
           (write-line % fd)
         )
         (not (close fd))
         (< 0 (setq dc (load_dialog tmp)))
         (new_dialog "StdEditBoxDialog"
                     dc
                     ""
                     (cond
                       (*cd-TempDlgPosition*)
                       ((quote (-1 -1)))
                     )
         )
       )
     )
    )
    (T
     (setq defval (substr (caddr Data) 1 Limit)
           res    (if (not (= defval ""))
                    (_CheckVal (car Data) (cadr Data) defval)
                  )
     )
     (mode_tile "edit" 2)
     (action_tile "edit" "(setq res (_CheckVal (car Data) (cadr Data) $value))")
     (action_tile (car BtnsLabel)
                  "(if res (setq *cd-TempDlgPosition* (done_dialog 1)))"
     )
     (action_tile (cadr BtnsLabel) "(setq res nil) (done_dialog 0)")
     (start_dialog)
    )
  )
  (if (< 0 dc) (unload_dialog dc))
  (if (setq tmp (findfile tmp)) (vl-file-delete tmp))
  (if (not DPos) (setq *cd-TempDlgPosition* (list -1 -1)))
  res
)