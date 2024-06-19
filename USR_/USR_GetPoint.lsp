; =========================================================================================== ;
; Pobiera punkt od uzytkownika / Gets point from user                                         ;
;  Msg [STR]      - komunikat do wyswietlenia / message to display                            ;
;  Bit [INT/nil]  - bit sterujacy (patrz initget) / control bit (see initget)                 ;
;  Pt  [LIST/nil] - punkt bazowy / base point                                                 ;
; ------------------------------------------------------------------------------------------- ;
; (cd:USR_GetPoint "\nWskaz punkt: " 1 nil)                                                   ;
; (cd:USR_GetPoint "\nWskaz drugi punkt: " 32 '(5 10 0))                                      ;
; =========================================================================================== ;
(defun cd:USR_GetPoint (Msg Bit Pt / res)
  (if Bit (initget Bit))
  (if
    (listp
      (setq res (vl-catch-all-apply
                  (quote getpoint)
                  (if Pt
                    (list Pt Msg)
                    (list Msg)
                  )
                )
      )
    )
    res
  )
)