; =========================================================================================== ;
; Wstawia odnośnik zewnętrzny / Attach Xref                                                   ;
;  Path  [STR]      - pełna ścieżka do pliku xref / xref full path                            ;
;  File  [STR]      - nazwa pliku odnośnika / xref file name                                  ;
;  Pb    [LIST]     - punkt wstawienia / insertion point                                      ;
;  Xyz   [LIST/nil] - LISTA = lista wspolczynnikow skali XYZ / list of X Y Z scale factor     ;
;                     nil   = X=Y=Z=1.0                                                       ;
;  Rot   [REAL/nil] - REAL = kat obrotu w radianach / rotation angle in radians               ;
;                     nil  = kat=0.0 / angle=0.0                                              ;
;  Ovlay [BOOL]     - typ odnośnika / reference type:                                         ;
;                     nil = dołącz / attachment                                               ;
;                     T   = nałóż / overlay                                                   ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_AttachXref "C:\\CAD" "Cad" '(5 5 5) '(10 10 10) 0.75 T)                             ;
; (cd:BLK_AttachXref "C:\\CAD\\" "Cad" '(5 5 5) '(10 10 10) 0.75 T)                           ;
; =========================================================================================== ;
(defun cd:BLK_AttachXref (Path File Pb Xyz Rot Ovlay / zdir xang res)
  (setq zdir (trans '(0 0 1) 1 0 T)
        xang (angle '(0 0 0) (trans (getvar "UCSXDIR") 0 zdir))
  )
  (if
    (not
      (vl-catch-all-error-p
        (setq res (vl-catch-all-apply
                    (quote vla-AttachExternalReference)
                    (list
                      (cd:ACX_ASpace)
                      (strcat (vl-string-right-trim "\\" Path) "\\" File)
                      File
                      (vlax-3d-point Pb)
                      (if (not Xyz) 1.0 (car Xyz))
                      (if (not Xyz) 1.0 (cadr Xyz))
                      (if (not Xyz) 1.0 (caddr Xyz))
                      (if (not Rot) 0.0 (+ Rot xang))
                      (if Ovlay
                        :vlax-true
                        :vlax-false
                      )
                    )
                  )
        )
      )
    )
    res
  )
)