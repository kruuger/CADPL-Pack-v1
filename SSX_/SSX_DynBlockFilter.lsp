; =========================================================================================== ;
; Filtr blokow dynamicznych / Dynamic block filter                                            ;
;  Mode [T/nil] - tryb wyboru blokow / block selection mode                                   ;
;                 nil - wskazanie uzytkownika / user selection                                ;
;                 T   - wszystkie z rysunku / all from drawing                                ;
;  Name [STR]   - nazwa bloku / block name                                                    ;
; ------------------------------------------------------------------------------------------- ;
; (cd:SSX_DynBlockFilter nil "Blok")                                                          ;
; =========================================================================================== ;
(defun cd:SSX_DynBlockFilter (Mode Name / res bl)
  (setq res (list '(0 . "INSERT")
                  (cons 2
                        (strcat "`"
                                (cd:STR_ReParse
                                  (mapcar (quote chr) (vl-string->list Name))
                                  "`"
                                )
                                (if (setq bl (cdr (cd:BLK_GetDynBlockNames Name)))
                                  (strcat ","
                                          (cd:STR_ReParse
                                            (mapcar
                                              (function (lambda (%) (strcat "`" %)))
                                              bl
                                            )
                                            ","
                                          )
                                  )
                                  ""
                                )
                        )
                  )
            )
  )
  (if Mode (ssget "_x" res) (ssget res))
)