; =========================================================================================== ;
; Pobiera slowa kluczowego od uzytkownika / Get a keyword from the user                       ;
;  Msg  [STR]  - tekst zapytania / query text                                                 ;
;  Keys [LIST] - lista mozliwych slow kluczowych / list of possible keywords                  ;
;  Def  [STR]  - domyslne slowo kluczowe / default keyword                                    ;
; ------------------------------------------------------------------------------------------- ;
; (cd:USR_GetKeyWord "\nUtworz blok" '("Anonimowy" "Nazwa") "Nazwa")                          ;
; =========================================================================================== ;
(defun cd:USR_GetKeyWord (Msg Keys Def / res key)
  (setq key (mapcar
              (function
                (lambda (%)
                  (cd:STR_ReParse Keys %)
                )
              )
              (list " " "/")
            )
  )
  (initget (car key))
  (setq res (vl-catch-all-apply
              (quote getkword)
              (list
                (strcat
                  Msg
                  " ["
                  (cadr key)
                  "] <"
                  (setq Def (if (not (member Def Keys))
                              (car Keys)
                              Def
                            )
                  )
                  ">: "
                )
              )
            )
  )
  (if res
    (if (= (type res) (quote STR)) res)
    Def
  )
)