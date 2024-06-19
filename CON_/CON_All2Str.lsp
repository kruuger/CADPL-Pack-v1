; =========================================================================================== ;
; Zmiana elementow listy na lancuchy tekstowe / Convert list elements onto strings            ;
;  Lst  [LIST]  - lista wejsciowa / input list                                                ;
;  Mode [T/nil] - nil = jak wynik z funkcji princ / as a result of the princ function         ;
;                 T   = jak wynik z funkcji prin1 / as a result of the prin1 function         ;
; ------------------------------------------------------------------------------------------- ;
; (cd:CON_All2Str '("A" "B" 1 3) nil) --> ("A" "B" "1" "3")                                   ;
; (cd:CON_All2Str '("A" "B" 1 3) T)   --> ("\"A\"" "\"B\"" "1" "3")                           ;
; =========================================================================================== ;
(defun cd:CON_All2Str (Lst Mode)
  (mapcar
    (function
      (lambda (%)
        (if Mode
          (vl-prin1-to-string %)
          (vl-princ-to-string %)
        )
      )
    )
    Lst
  )
)