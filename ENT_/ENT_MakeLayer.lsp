; =========================================================================================== ;
; Tworzy nowa warstwe / Creates a new layers                                                  ;
;  Name [STR] - nazwa warstwy / layer name                                                    ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_MakeLayer "ABC")                                                                    ;
; =========================================================================================== ;
(defun cd:ENT_MakeLayer (Name / en)
  (if (setq en (tblobjname "LAYER" Name))
    en
    (entmakex
      (list
        (cons 0 "LAYER")
        (cons 100 "AcDbSymbolTableRecord")
        (cons 100 "AcDbLayerTableRecord")
        (cons 2 Name)
        (cons 70 0)
      )
    )
  )
)