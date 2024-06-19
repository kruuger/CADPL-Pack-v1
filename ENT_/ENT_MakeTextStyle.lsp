; =========================================================================================== ;
; Tworzy nowy stylu tekstu / Creates a new text style                                         ;
;  Name [STR] - nazwa stylu tekstu / text style name                                          ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_MakeTextStyle "ABC")                                                                ;
; =========================================================================================== ;
(defun cd:ENT_MakeTextStyle (Name / en)
  (if (setq en (tblobjname "STYLE" Name))
    en
    (entmakex
      (list
        (cons 0 "STYLE")
        (cons 100 "AcDbSymbolTableRecord")
        (cons 100 "AcDbTextStyleTableRecord")
        (cons 2 Name)
        (cons 70 0)
      )
    )
  )
)