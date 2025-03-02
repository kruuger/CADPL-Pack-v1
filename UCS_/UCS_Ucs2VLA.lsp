; =========================================================================================== ;
; Zmiana nazwy ucs na obiekt VLA / Convert ucs name to VLA-Object                             ;
;  Ucs [STR] - nazwa uklad wspolrzednych / coordinate system name                             ;
; ------------------------------------------------------------------------------------------- ;
; (cd:UCS_Ucs2VLA "North")                                                                    ;
; =========================================================================================== ;
(defun cd:UCS_Ucs2VLA (Ucs / res) 
  (and 
    (tblsearch "UCS" Ucs)
    (setq res (vla-item 
                (cd:ACX_Ucss)
                Ucs
              )
    )
  )
  res
)