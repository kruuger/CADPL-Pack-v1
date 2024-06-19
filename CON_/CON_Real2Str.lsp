; =========================================================================================== ;
; Konwertuje liczbe na lancuch tekstowy / Converts number to a string                         ;
;  Val  [REAL/INT] - liczba do konwersji / conversion number                                  ;
;  Unit [INT/nil]  - jednostki wyjsciowe / output unit                                        ;
;                    nil = domyslne / default | (getvar "LUNITS")                             ;
;                    1   = naukowe / scientific                                               ;
;                    2   = dziesietne / decimal                                               ;
;                    3   = inzynierskie / engineering                                         ;
;                    4   = architektoniczne / architectural                                   ;
;                    5   = ulamkowe / fractional                                              ;
;  Prec [INT/nil]  - INT = liczba miejsc po przecinku / number of decimal places              ;
;                    nil = domyslna / default | (getvar "LUPREC")                             ;
; ------------------------------------------------------------------------------------------- ;
; (cd:CON_Real2Str 12 2 4)                                                                    ;
; =========================================================================================== ;
(defun cd:CON_Real2Str (Val Unit Prec / DMZ res)
  (setq DMZ (getvar "DIMZIN"))
  (setvar "DIMZIN"
          (if (not (member (getvar "LUNITS") (list 4 5)))
            (logand DMZ (~ 8))
            0
          )
  )
  (setq res (rtos
              Val
              (if (and Unit (member Unit (list 1 2 3 4 5)))
                Unit
                (getvar "LUNITS")
              )
              (if Prec Prec (getvar "LUPREC"))
            )
  )
  (setvar "DIMZIN" DMZ)
  res
)