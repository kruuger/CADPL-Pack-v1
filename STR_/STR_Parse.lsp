; =========================================================================================== ;
; Dzieli lancuch separatorem / Divide string by separator                                     ;
;  Str [STR]   - lancuch tekstowy / string                                                    ;
;  Sep [STR]   - znak rozdzielajacy / string separator                                        ;
;  Rbl [T/nil] - nil = nie usuwa pustych tekstow / don't remove empty strings                 ;
;                T   = usuwa puste teksty / remove empty strings                              ;
; ------------------------------------------------------------------------------------------- ;
; (cd:STR_Parse ";;1;2;3;;;9;" ";" nil) --> ("" "" "1" "2" "3" "" "" "9" "")                  ;
; (cd:STR_Parse ";;1;2;3;;;9;" ";" T)   --> ("1" "2" "3" "9")                                 ;
; =========================================================================================== ;
(defun cd:STR_Parse (Str Sep Rbl / el res)
  (setq el "")
  (foreach % (vl-string->list Str)
    (if (= Sep (chr %))
      (setq res (cons el res)
            el  ""
      )
      (setq el (strcat el (chr %)))
    )
  )
  (setq res (cons el res))
  (reverse
    (if Rbl (vl-remove "" res) res)
  )
)