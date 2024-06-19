; =========================================================================================== ;
; Tworzy nowa warstwe / Creates a new layers                                                  ;
;  Name [STR] - nazwa warstwy / layer name                                                    ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddLayer "ABC")                                                                     ;
; =========================================================================================== ;
(defun cd:ACX_AddLayer (Name)
  (if (tblobjname "LAYER" Name)
    (vla-item (cd:ACX_Layers) Name)
    (if (snvalid Name 0)
      (vla-add (cd:ACX_Layers) Name)
    )
  )
)