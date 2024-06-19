; =========================================================================================== ;
; Liczba wystapien znaku / Number of occurrences of a character                               ;
;  Str  [STR] - lancuch tekstowy / string                                                     ;
;  Char [STR] - znak / character                                                              ;
; ------------------------------------------------------------------------------------------- ;
; (cd:STR_CountChar  "\"123\" \"416\" \"719\" \"A1c\"" "\"")                                  ;
; =========================================================================================== ;
(defun cd:STR_CountChar (Str Char)
  (-
    (strlen Str)
    (length
      (vl-remove
        (ascii Char)
        (vl-string->list Str)
      )
    )
  )
)