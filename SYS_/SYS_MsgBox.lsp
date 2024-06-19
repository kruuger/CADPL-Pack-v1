; =========================================================================================== ;
; Standardowe okno komunikatu / Standard message box                                          ;
;  Msg   [STR]           - komunikat do wyswietlenia / message to display                     ;
;  Title [STR]           - tytul okna / window title                                          ;
;  Btn   [0/1/2/3/4/5/6] - przyciski / buttons                                                ;
;  Icon  [16/32/48/64]   - wyswietlany symbolu / displayed symbol                             ;
; ------------------------------------------------------------------------------------------- ;
; Typy przyciskow / Buttons type:                                                             ;
;  0  = OK                              / OK                                                  ;
;  1  = OK i Anuluj                     / OK and Cancel                                       ;
;  2  = Przerwij, Ponow probe i Ignoruj / Abort, Retry and Ignore                             ;
;  3  = Tak, Nie i Anuluj               / Yes, No and Cancel                                  ;
;  4  = Tak i Nie                       / Yes and No                                          ;
;  5  = Ponow probe i Anuluj            / Retry and Cancel                                    ;
;  6  = Anuluj, Ponow probe Kontynuuj   / Cancel, Try Again and Continue                      ;
; ------------------------------------------------------------------------------------------- ;
; Wyswietlany symbol / Displayed symbol:                                                      ;
;  16 = "Stop"       [X] / "Stop"                                                             ;
;  32 = "Pytanie"    [?] / "Question"                                                         ;
;  48 = "Uwaga"      [!] / Show "Exclamation"                                                 ;
;  64 = "Informacja" [i] / Show "Information"                                                 ;
; ------------------------------------------------------------------------------------------- ;
; Zwraca / Return:                                                                            ;
;  1  = OK          / OK                                                                      ;
;  2  = Anuluj      / Cancel                                                                  ;
;  3  = Przerwij    / Abort                                                                   ;
;  4  = Ponow probe / Retry       | Btn = 2,5                                                 ;
;  5  = Ignoruj     / Ignore                                                                  ;
;  6  = Tak         / Yes                                                                     ;
;  7  = Nie         / No                                                                      ;
;  10 = Ponow probe / Try Again   | Btn = 6                                                   ;
;  11 = Kontynuuj   / Continue                                                                ;
; ------------------------------------------------------------------------------------------- ;
; (cd:SYS_MsgBox "Komunikat\nw 2 liniach" "Uwaga" 0 64)                                       ;
; =========================================================================================== ;
(defun cd:SYS_MsgBox (Msg Title Btn Icon / WSs res)
  (setq WSs  (vlax-create-object "WScript.Shell")
        Icon (if (member Icon (list 16 32 48 64)) Icon 0)
        Btn  (if (member Btn (list 0 1 2 3 4 5 6)) Btn 0)
  )
  (setq res (vlax-invoke-method WSs
                                "Popup"
                                (if (not Msg) "" Msg)
                                0
                                (if (not Title) "" Title)
                                (+ Btn Icon 4096)
            )
  )
  (vlax-release-object WSs)
  res
)