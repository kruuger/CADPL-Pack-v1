; =========================================================================================== ;
; Laduje definicje rodzaju linii z pliku LIN / Loads linetype definition from LIN file        ;
;  Name [STR] - nazwa warstwy / layer name                                                    ;
;  File [STR] - nazwa pliku LIN / LIN file name                                               ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_LoadLineType "HIDDEN" "acadiso.lin")                                                ;
; =========================================================================================== ;
(defun cd:ACX_LoadLineType (Name File / res)
  (setq res (if (tblobjname "LTYPE" Name)
              (vla-item (cd:ACX_LineTypes) Name)
              (if (snvalid Name 0)
                (vl-catch-all-apply
                  (quote vla-load)
                  (list (cd:ACX_LineTypes) Name File)
                )
              )
            )
  )
  (if (= (type res) (quote VLA-OBJECT)) res)
)