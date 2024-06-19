; =========================================================================================== ;
; Wstawia blok / Inserts a block                                                              ;
;  Pb   [LIST]      - punkt wstawienia / insertion point                                      ;
;  Name [STR]       - nazwa bloku lub rysunku (bez .dwg) / block or drawing name (no .dwg)    ;
;  Xyz  [LIST/nil]  - LISTA = lista wspolczynnikow skali XYZ / list of X Y Z scale factor     ;
;                     nil   = X=Y=Z=1.0                                                       ;
;  Rot  [REAL/nil]  - REAL = kat obrotu w radianach / rotation angle in radians               ;
;                     nil  = kat=0.0 / angle=0.0                                              ;
;  Sup  [T/nil]     - szukaj w sciezkach poszukiwan / search at support path                  ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_InsertBlock '(0 0 0) "d:\\blok" '(2 2 2) 0 T)                                       ;
; =========================================================================================== ;
(defun cd:BLK_InsertBlock (Pb Name Xyz Rot Sup / zdir xang res)
  (setq zdir (trans '(0 0 1) 1 0 T)
        xang (angle '(0 0 0) (trans (getvar "UCSXDIR") 0 zdir))
  )
  (if
    (not
      (vl-catch-all-error-p
        (setq res (vl-catch-all-apply
                    (quote vla-InsertBlock)
                    (list
                      (cd:ACX_ASpace)
                      (vlax-3d-point (trans Pb 1 0))
                      (if (tblsearch "BLOCK" Name)
                        Name
                        (if Sup
                          (findfile (strcat Name ".dwg"))
                          nil
                        )
                      )
                      (if (not Xyz) 1.0 (car Xyz))
                      (if (not Xyz) 1.0 (cadr Xyz))
                      (if (not Xyz) 1.0 (caddr Xyz))
                      (if (not Rot) 0.0 (+ Rot xang))
                    )
                  )
        )
      )
    )
    res
  )
)