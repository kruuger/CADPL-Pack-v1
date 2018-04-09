; =========================================================================================== ;
; Tworzy nowy stylu tekstu / Creates a new text style                                         ;
;  Name [STR] - nazwa stylu tekstu / text style name                                          ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddTextStyle "ABC")                                                                 ;
; =========================================================================================== ;
(defun cd:ACX_AddTextStyle (Name)
  (if (tblobjname "STYLE" Name)
    (vla-item (cd:ACX_TextStyles) Name)
    (if (snvalid Name 0)
      (vla-add (cd:ACX_TextStyles) Name)
    )
  )
)